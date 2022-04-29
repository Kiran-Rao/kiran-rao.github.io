---
layout: post
title: 'Changing Tires at 100mph: A Guide to Zero Downtime Migrations'
date: 2022-04-22
author: Kiran Rao
---

At The League, a common task was migrating a database schema.
This was done to improve query performance, change column names/types, or to adapt data to new use cases.
While this may seem like a straightforward set of SQL commands, it becomes a complex coreographed dance on production to be achieved with zero downtime.
The steps are as follows:

1. Create the new table
1. Write to both old and new table
1. Copy data (in chunks) from old to new
1. Validate consistency
1. Switch reads to new table
1. Stop writes to the old table
1. Cleanup old table

This guide will go through the step by step process of migrating a table `old` to `new` in PostgreSQL. While the examples are for a PostgreSQL table migration, the same steps can apply to almost any migration. Normalized schema design, index selection, and performance optimization are outside the scope of this guide.

## Background

### Existing Schema

Let's assume we're given an existing schema with a table named `old`:

```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS old (
    old_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    data TEXT NOT NULL
);
```

We also have an API that can run the following CRUD operations against the table:

<img class="diagram" src="/assets/migration-old-schema.svg" alt="Old" width="50%" >

```sql
-- Create
INSERT INTO old (data)
VALUES (?)
RETURNING *;

-- Read
SELECT *
FROM old
WHERE old_id = ?;

-- Update
UPDATE old
SET data = ?
WHERE old_id = ?;

-- Delete
DELETE
FROM old
WHERE old_id = ?;
```

### Desired schema

The `data` column was type `TEXT` for flexibility.
It is now used exclusively for timestamps.
We then get a request from product on a hot codepath to be count all entries between 2 timestamps.
While this is possible with the current schema, we decided a better approach would be to update `data` to be a `TIMESTAMP` type.
In addition, `old` is no longer an accurate name, and that `new` would be a lot better.

<img class="diagram" src="/assets/migration-new-schema.svg" alt="New schema" width="50%" >

```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS new (
    new_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_date TIMESTAMP WITH TIME ZONE NOT NULL
);
```

### Migration Requirements

We can further specify the requirements through the migration:

- The system must fully respond to requests throughout the migration process
- No action can take a write lock against a significant percentage of the table[^write_lock]
- No unsafe operations [^safe_unsafe]
- We must be able to roll-back any changes to the previous step if we encounter issues

[^safe_unsafe]: [Safe and unsafe operations for high volume PostgreSQL](https://leopard.in.ua/2016/09/20/safe-and-unsafe-operations-postgresql)
[^write_lock]: [Write Locks](https://www.postgresql.org/docs/current/sql-lock.html)

## Procedure

### Create a new table

<img class="diagram" src="/assets/migration-new-table.svg" alt="Create a new table" width="50%" >

```sql
CREATE TABLE IF NOT EXISTS new (
    new_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_date TIMESTAMP WITH TIME ZONE NOT NULL
);
```

### Write to both tables

Now that we have two tables, we write to both simultaneously.

<img class="diagram" src="/assets/migration-write-both.svg" alt="Write to both tables" width="50%" >

```sql
-- Create
WITH new_rows AS (
    INSERT INTO new (created_date)
    VALUES (?)
    RETURNING *
)
INSERT
INTO old (old_id, data)
SELECT new_id, CAST(created_date AS TEXT)
FROM new_rows
RETURNING *;

-- Update
UPDATE old
SET data = ?
WHERE old_id = ?;

UPDATE new
SET created_date = ?
WHERE new_id = ?;


-- Delete
DELETE
FROM old
WHERE old_id = ?;

DELETE
FROM new
WHERE new_id = ?;
```

Note that our create operation appears slightly more complex than before.
We are creating a row in the new table, then using the record to populate the values of the old table.
This is all done in a single transaction to ensure our randomly generated UUIDs in sync.

### Copy data to new table

Once we know that all new records will be replicated, we can start copy old records.

<img class="diagram" src="/assets/migration-copy-data.svg" alt="Replicate data between tables" width="50%" >

```sql
INSERT INTO new(new_id, created_date)
SELECT old_id, CAST(data AS TIMESTAMP)
FROM OLD
WHERE NOT EXISTS(SELECT *
                 FROM new
                 WHERE new_id = OLD.old_id)
LIMIT 1000
RETURNING *;
```

We are inserting values into the `new` table from the `old` table that don't yet exist in `new`.
To keep the database responsive, we perform the operation in chunks with `limit 1000`.
This can be tuned up or down depending on the table, though better to use smaller chunks and avoid large write locks.

### Validate consistency

The often overlooked step. Before we switch over the reads, we should ensure that our data is fully in sync between tables. Here are a few sample queries to validate. The most common culpret was a system we never knew about was writing to this table.

Are we missing any records?

```sql
SELECT *
FROM old
    FULL OUTER JOIN new ON old_id = new_id
WHERE new_id IS NULL
   OR old_id IS NULL
```

Is any data inconsistent?

```sql
SELECT *
FROM old
    INNER JOIN new ON old_id = new_id
WHERE CAST(data AS TIMESTAMP) <> created_date
```

### Switch reads

This is usually the hardest step, since we often have reads in may different places. Since that data is in sync between tables, we can take our time with this part of the migration.

<img class="diagram" src="/assets/migration-switch-reads.svg" alt="Switch reads" width="50%" >

```sql
SELECT *
FROM new
WHERE new_id = ?;
```

This stage is where we'd update our views, foreign keys, triggers, etc to reference the new table.

### Stop writes

<img class="diagram" src="/assets/migration-drop-writes.svg" alt="Drop writes" width="50%" >

Now that we've switch all reads over to the new system, we no longer need to update the old database. Our new write operations:

```sql
-- Create
INSERT INTO new (created_date)
VALUES (?)
RETURNING *

-- Update
UPDATE new
SET created_date = ?
WHERE new_id = ?;

-- Delete
DELETE
FROM new
WHERE new_id = ?;
```

### Cleanup table

When we're confident that our system no longer references the old table, we can drop it.

<img class="diagram" src="/assets/migration-new-schema.svg" alt="New schema" width="50%" >

```sql
DROP TABLE IF EXISTS old;
```

## Done

Congradulations! Migration Complete!

<img class="diagram" src="/assets/its_done.gif" alt="It's done GIF">

Now the hardest part: explaining to product why their seemingly small request took 3x longer than expected. If it helps you can send them this article. Good luck!
