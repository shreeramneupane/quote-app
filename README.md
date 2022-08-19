# README

## Project Info
* Ruby version: 3.1.2
* Rails version: 7.0.3.1
* Database: PostgreSQL [9.3.x or later]

## Dev Env Setup
### DB
- Copy the database.yml.sample to database.yml `cp database.sample.yml database.yml`
- And If necessary, change db access attributes
- Run command `rails db:setup` to create and seed data
- run test cases with command `rspec`

## Randomization
- Postgres `RANDOM()` method provides a random record [https://www.postgresql.org/docs/9/functions-math.html]
- This method samples whole dataset, so if dataset starts growing then it is important to use `TABLESAMPLE SYSTEM_ROWS` also
