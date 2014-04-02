# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
DivvyData::Application.initialize!

DivvyData::Application.configure do
  config.assets.precompile += %w( *.js *.css )
end
