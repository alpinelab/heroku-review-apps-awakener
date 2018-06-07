require 'rubygems'
require 'bundler/setup'
require 'platform-api'

def review_apps_to_wake_up
  PlatformAPI.connect(ENV['HEROKU_API_KEY']).app.list.map do |app|
    app["name"] if app["name"].include?("sirac-staging-pr-")
  end.compact
end

def with_maintenance_mode(app)
  system "heroku maintenance:on --app #{app}"
  yield
  system "heroku maintenance:off --app #{app}"
end

def capture_database(app)
  system "heroku pg:backups:capture --app #{app}"
end

def restore_database(app)
  system "heroku pg:backups:restore --app {app} --confirm #{app}"
end

review_apps_to_wake_up.each do |app|
  with_maintenance_mode(app) do
    capture_database(app)
    restore_database(app)
  end
end
