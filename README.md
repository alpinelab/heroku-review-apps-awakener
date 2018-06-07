# Heroku review apps AWAKENER 📢 😴

This script keeps Heroku review apps database read-write for configured parent apps, even if they exceed 10k lines.

## Setup

1. Deploy this code to a Heroku app
2. Add the Heroku CLI buildpack and configure it:

    ```shell
    heroku buildpacks:add -i 1 https://github.com/heroku/heroku-buildpack-cli
    heroku config:set HEROKU_API_KEY=$(heroku auth:token)
    ```

3. Add the Heroku scheduler:

    ```shell
    heroku addons:create scheduler:standard
    ```

4. Configure it to start `ruby heroku_review_apps_awakener.rb` whenever you like (we do it everyday at 5am and 9pm UTC)

5. Configure the parent apps you want review apps to me awaken:

    ```shell
    heroku config:set PARENT_APPS="my-awesome-app another-awesome-app"
    ```

6. Enjoy always-read-write database for your review apps :tada:

## Why?

With [Heroku Pipeline](https://devcenter.heroku.com/articles/pipelines), every GitHub pull request can generate a [review app](https://devcenter.heroku.com/articles/github-integration-review-apps).

A common trick is to attach the parent app database as `PARENT_DATABASE` then to copy its content on each provisioned review app database by adding the following in `app.json`:

```json
  "scripts": {
    "postdeploy": "pg_dump ${PARENT_DATABASE_URL} | psql ${DATABASE_URL}"
  },
```

The problem is that review apps can only use Heroku Postgres free plan, which has maximum allowed capacity of 10,000 lines. If you exceed it (which can happen very quickly when copying the full database content of the parent app), Heroku disrupts it after 24 hours by setting it read-only :scream:

The solution is to force a PG backup restore (`heroku pg:backups restore`) to reset the 24 hours read-write grace period.

## License

This project is developed by [Alpine Lab](https://www.alpine-lab.com) and released under the terms of the [MIT license](LICENSE.md).

<a href="https://www.alpine-lab.com"><img src="alpinelab-logo.png" width="40%" /></a>
