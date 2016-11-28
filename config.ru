require 'rubygems'
require 'bundler'

Bundler.require

require 'sinatra/asset_pipeline'

%w(
  /config/initializers/**/*.rb
  /lib/**/*.rb
)
  .map { |pattern| Dir[File.dirname(__FILE__) + pattern] }
  .flatten
  .each { |f| require f }

Arena.configure do |config|
  config.application_id = ENV['ARENA_CLIENT_ID']
  config.application_secret = ENV['ARENA_CLIENT_SECRET']
  config.access_token = ENV['ARENA_AUTH_TOKEN']
end

require './application'

run Application
