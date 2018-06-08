# Heroku review apps AWAKENER 📢 😴

This script keeps Heroku review apps database read-write for configured parent apps, even if they exceed 10k lines.

## Setup

1. Deploy this code to a Heroku app:

    [![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/alpinelab/heroku-review-apps-awakener)

2. Configure the [Heroku Scheduler](https://devcenter.heroku.com/articles/scheduler) to start `ruby heroku_review_apps_awakener.rb` whenever you like (we do it everyday at 5am and 9pm UTC)

3. Enjoy always-read-write database for your review apps :tada:

## Why?

With [Heroku Pipeline](https://devcenter.heroku.com/articles/pipelines), every GitHub pull request can generate a [review app](https://devcenter.heroku.com/articles/github-integration-review-apps).

A common trick is to:

1. attach the parent app database as `PARENT_DATABASE` using:

    ```shell
    heroku addons:attach DATABASE PARENT_DATABASE
    ```

2. make it available to review apps from `app.json`:

    ```json
    "env": {
      "PARENT_DATABASE_URL": { "required": true }
    }
    ```

3. copy the parent database content on each provisioned review app database (again, from `app.json`):

    ```json
    "scripts": {
      "postdeploy": "pg_dump ${PARENT_DATABASE_URL} | psql ${DATABASE_URL}"
    }
    ```

The problem is that review apps can only use Heroku Postgres free plan, which has a maximum allowed capacity of 10,000 lines. If you exceed it, Heroku disrupts it after 24 hours by setting it read-only :sob:

The solution is to force a PG backup restore (`heroku pg:backups restore`) to reset the 24 hours read-write grace period.

## License

This project is developed by [Alpine Lab](https://www.alpine-lab.com) and released under the terms of the [MIT license](LICENSE.md).

<a href="https://www.alpine-lab.com"><img src=".github/alpinelab-logo.png" width="40%" /></a>
