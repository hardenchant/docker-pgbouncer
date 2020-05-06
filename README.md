# Dockerized version of PgBouncer

PgBouncer is a lightweight connection pooler for PostgreSQL.


**Current version 1.13.0**

See the [PgBouncer website](http://www.pgbouncer.org) for more information.


### Fast patch your Postgres app with PgBouncer
**Warning:** Examine pgbouncer_template.ini before starting, user auth set to trust (without password).

```
$ docker build . -t pgbouncer
$ docker run -eMAX_CLIENT_CONN=100 -ePOOL_SIZE=20 -eDB_HOST=pg_host -eDB_USER=pg_user -eDB_PASS=pg_user_pass -d -p 5432:5432 pgbouncer
```
Then set DB_HOST for your application to host which contains pgbouncer docker instance.

### TODO
- [x] support environment variables
- [ ] auth user with password-sha256
- [ ] carefully inspect pgbouncer configuration
