require "platform-api"

def indexer
  PlatformAPI.connect(ENV["HEROKU_API_KEY"]).app.list.map do |app|
    app["name"] if app["name"].end_with?("-staging")
  end.compact
end

indexer
