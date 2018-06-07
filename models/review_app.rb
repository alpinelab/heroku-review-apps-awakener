require "platform-api"

class ReviewApp
  REVIEWAPP_REGEX = /-pr-\d+\z/

  attr_reader :name

  class << self
    def for(*parent_app_names)
      all.select do |app|
        parent_app_names.any? do |parent_app_name|
          app.name.match? Regexp.new(parent_app_name + REVIEWAPP_REGEX.to_s)
        end
      end
    end

  private

    def all
      find_all_names.map do |app_name|
        new(app_name)
      end
    end

    def find_all_names
      PlatformAPI.connect(ENV["HEROKU_API_KEY"]).app.list.map do |app|
        app["name"] if app["name"].match? REVIEWAPP_REGEX
      end.compact
    end
  end

  def initialize(name)
    @name = name
  end

  def wake_up
    with_maintenance_mode do
      capture_database
      restore_database
    end
  end

private

  def with_maintenance_mode
    system "heroku maintenance:on --app #{name}"
    yield
    system "heroku maintenance:off --app #{name}"
  end

  def capture_database
    system "heroku pg:backups:capture --app #{name}"
  end

  def restore_database
    system "heroku pg:backups:restore --app #{name} --confirm #{name}"
  end
end
