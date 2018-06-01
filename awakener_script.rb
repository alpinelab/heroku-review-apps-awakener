require 'rubygems'
require 'bundler/setup'

system("curl -s https://cli-assets.heroku.com/heroku-cli/channels/stable/heroku-cli-linux-x64.tar.gz | tar -zx && mv heroku-cli* heroku-client")
ENV["PATH"] = "/app/heroku-client/bin:#{ENV["PATH"]}"

def restore_db(heroku_app_name)
  puts "rescue #{heroku_app_name}"
  system "heroku maintenance:on -a #{heroku_app_name}"
  puts "maintenance ON"
  system "heroku pg:backups:capture -a #{heroku_app_name}"
  puts "backups:capture ok"
  system "heroku pg:backups:restore -a #{heroku_app_name} --confirm #{heroku_app_name}"
  puts "backups:restore ok"
  system "heroku maintenance:off -a #{heroku_app_name}"
  puts "maintenance OFF"
end

heroku_withAPIkey = PlatformAPI.connect(ENV['HEROKU_API_KEY'])
review_apps = heroku_withAPIkey.app.list.select{ |app| app["name"].include?("sirac-staging-pr-") }.map{ |app| app["name"] }
puts "#{review_apps.count} review apps detected"

review_apps.each { |app_name| puts "#{app_name} has to be restored" }
# review_apps.each { |app_name| restore_db(app_name) }

puts "the end"
