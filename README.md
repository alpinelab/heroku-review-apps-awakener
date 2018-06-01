# heroku-review-apps-awakener
An Heroku app that monitor Heroku review apps and keeps their database awake

With Heroku pipeline, every pull request generate a review app, whose database size exceeds the capacity of 10,000 lines of the free plan.

Solution was, for each review app, to launch every day this recuperation sequence:

* `heroku maintenance:on`
* `heroku pg:backups:capture`
* `heroku pg:backups:restore`
* `heroku maintenance:off`

Purpose of the heroku-review-apps-awakener is to automatise this painful operation, by scheduling with Heroku Scheduler the action:

` ruby awakener_script.rb `

This ruby script use :
* `ruby 2.5.1`
* `gem platform-api 2.1.0`
* `ENV['HEROKU_API_KEY']` to connect with our Heroku account

It allows to count, list and execute on each review app of Sirac repository the recuperation sequence.

For now, this script is only available for Sirac repository...
