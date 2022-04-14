---
layout: post
title: 'Changing Tires at 100mph: A Guide to Zero Downtime Migrations'
date: 2022-04-14
author: Kiran Rao
---

At The League, a challenge we often faced was migrating database schemas.
We would often do this when queries were performing poorly, column types incorrect, or the tables were created years ago for a silghtly different use case.
While this may seem like a straightforward set of SQL commands, it can become a complex coreographed dance on production to be achieved with zero downtime and no undesired data loss.

This guide will go through the step by step process of migrating a table `old` to `new` in PostgreSQL. While the examples are for a PostgreSQL table migration, the same steps can apply to almost any migration. Note that normalized schema design, index selection, and performance optimization are outside the scope of this guide.

## Background

Let's start by defining a schema for ourselves:

```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS old (
    old_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    data TEXT NOT NULL
);
```

We also have an API that can run the following CRUD operations against the database:

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

### New schema

Some time passes and we notice that data is being used exclusively to record a timestamps.
In addition, `old` is no longer an accurate name, and that `new` would be a lot better.
In the future, we want our schema to look like:

```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS new (
    new_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_date TIMESTAMP WITH TIME ZONE NOT NULL
);
```

### Migration Requirements

We can further quantify constraints as follows:

- The system must fully respond to requests throughout the migration process
- No action can take a write lock against a significant percentage of the table
- No unsafe operations [^1]
- We must be able to roll-back any changes to the previous step if we encounter issues

[^1]: https://leopard.in.ua/2016/09/20/safe-and-unsafe-operations-postgresql

## Procedure

### Create a new table

```sql
CREATE TABLE IF NOT EXISTS new (
    new_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_date TIMESTAMP WITH TIME ZONE NOT NULL
);
```

### Write to both tables

Now that we have two tables, we write to both simultaneously.

```sql
-- Create
WITH new_rows AS (
    INSERT INTO new (created_date) VALUES (?)
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

### Migrate data

Once we know that all new records will be replicated, we can start migrating old records. It should look something like this:

```sql
INSERT INTO new(new_id, created_date)
SELECT old_id, CAST(data AS TIMESTAMP)
FROM OLD
WHERE NOT EXISTS(SELECT *
                 FROM NEW
                 WHERE new_id = OLD.old_id)
LIMIT 1000
RETURNING *;
```

We are inserting values into the `new` table from the `old` table that don't yet exist in `new`.
To keep the database responsive, we perform the operation in chunks with `limit 1000`.
This can be tuned up or down depending on the table, though better to use smaller chunks and avoid large write locks.

### Validate Data

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

### Switch Reads

This is usually the
