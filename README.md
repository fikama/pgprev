# $ PGPREV - Postgres 🐘 preview
### About
Bash script for previewing Postgres tables in the browser.
### Goal
I use psql for Postgres management, and it's great but previewing tables in a terminal isn't especially pleasant. There are plenty of solutions for managing Postgres databases but I wanted something simpler and this is how pgprev was born! Executed from a terminal but displayed in a browser, perfectly suit my workflow which mostly consists of these two apps.
### Usage
#### Connecting to Postgres server
Pgprev uses psql for retrieving data from Postgres server, you can provide connection information via Connection URIs (see [34.1.1.2](https://www.postgresql.org/docs/14/libpq-connect.html#:~:text=34.1.1.2.%C2%A0Connection%20URIs) in Postgres documentation)
You can also save Postgres Connection URI in an environemt variable named PSQLPATH, you can set PSQLPATH per-directory using [direnv](https://direnv.net/) so you can have different PSQLPATHs for each of your projects.
#### Default Behaviour (without flags)
On deafault, pgprev will open all of the tables that are present in chosen database
#### Arguments (Flags)
- `-h` print help message
- `-f` load queries from file*
- `-q` provide exact (single) query
- `-p` provide connection URI for connecting to Postgres server

\* files syntax looks like this:
```
SELECT * FROM pg_database
SELECT * FROM pg_class
```
It is just a couple of SQL commands separated by newline


### Installation on Linux (Other platforms unsupported)
#### Steps
1. Just download pgprev file and save it somewhere in your $PATH
#### Dependencies
- psql
- bash
- chromium (you could propably get it work with others browsers too)


# Debugging
- There is no indication that psql can't connect to Postgres server, so remember to chkeck if Postgres server is up and running.
