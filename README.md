# README

Demo: https://glacial-refuge-25927.herokuapp.com

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

## Parsing the quote csv
- The title column has both the quote's title and author, so logic is implemented to distinguish each other
-- Most of the title are enclosed within “”, '' or ""; and the remaining section is about author
-- Otherwise title and author are separated by special character - — ~
- These above case parse more than 95% of the data
### Further
- There are numerous test cases that are failing, which covers the remaining 5% of the parsing

## Unit Test
- run command `rspec`
- 27 test case are failing, all of these are related to parsing the title and author
