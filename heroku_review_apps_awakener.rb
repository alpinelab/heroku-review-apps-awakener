require "bundler/setup"

Dir[File.join(__dir__, "models", "**", "*.rb")].each do |file|
  require file
end

if ENV["PARENT_APPS"].nil?
  puts "Error: PARENT_APPS must be set"
  exit 78 # EX_CONFIG
end

ReviewApp.for(*ENV["PARENT_APPS"].split).map(&:wake_up)
