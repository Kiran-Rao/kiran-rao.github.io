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

We'll start by defining a schema for ourselves:

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

### New Schema

### Requirements

We can further quantify constraints as follows:

- The system must fully respond to requests throughout the migration process
- No action can take a write lock against a significant percentage of the table
- No "dangerous" actions
- We must be able to roll-back any changes to the previous step if there are issues
