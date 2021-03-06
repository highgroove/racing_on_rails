require File.expand_path("../boot", __FILE__)
require "rails/all"

if defined?(Bundler)
  Bundler.require(:default, Rails.env)
  Bundler.require *Rails.groups(:assets => %w(development test))
end

module RacingOnRails
  class Application < Rails::Application    


=begin
  if Rails.env.development?
     config.middleware.use Rack::GoogleAnalytics, :tracker => 'UA-36359016-1'
      config.middleware.use Rack::GoogleAnalytics, :tracker => 'UA-36315439-1'
    end

    if Rails.env.staging?
      config.middleware.use Rack::GoogleAnalytics, :tracker => 'UA-36359016-1'
    end

    if Rails.env.production?
      config.middleware.use Rack::GoogleAnalytics, :tracker => 'UA-36315439-1'
    end
=end

    config.autoload_paths += %W( 
      #{config.root}/app/models/competitions 
      #{config.root}/app/models/observers 
      #{config.root}/app/pdfs 
      #{config.root}/app/rack 
      #{config.root}/lib
      #{config.root}/lib/racing_on_rails 
      #{config.root}/lib/results
      #{config.root}/lib/sentient_user
    )





    config.encoding = "utf-8"
    
    config.assets.enabled = true
    config.assets.version = "1.0"
    config.assets.paths.insert 0, Rails.root.join("local", "app", "assets", "images")
    config.assets.paths.insert 0, Rails.root.join("local", "app", "assets", "javascripts")
    config.assets.paths.insert 0, Rails.root.join("local", "app", "assets", "stylesheets")
    config.assets.paths << Rails.root.join("app", "assets", "stylesheets")
  
    config.time_zone = "Pacific Time (US & Canada)"
    
    # Racing on Rails has many foreign key constraints, so :sql is required
    config.active_record.schema_format = :sql
  
    unless ENV["SKIP_OBSERVERS"]
      config.active_record.observers = :event_observer, :name_observer, :person_observer, :race_observer, :result_observer, :team_observer
    end
  
    config.filter_parameters += [ :password, :password_confirmation ]
  
    # HP's proxy, among others, gets this wrong
    config.action_dispatch.ip_spoofing_check = false

    config.action_dispatch.session = {
      :key => "_gbra_session",
      :secret => "cIIrj9TWoeH2YVjLdGyqg6UHYCjcYc"
    }

    require "#{config.root}/app/helpers/racing_on_rails/form_builder"
    config.action_view.default_form_builder = ::RacingOnRails::FormBuilder

    if File.exists?("#{config.root}/local/config/database.yml")
      Rails.configuration.paths["config/database"] = [ "local/config/database.yml", "config/database.yml" ]
    end
  end  
end
