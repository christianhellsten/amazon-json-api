#
# Phusion Passenger configuration
#
require 'app'
root_dir = File.dirname(__FILE__)

set :environment, :production
set :root,  root_dir
set :app_file, File.join(root_dir, 'app.rb')
disable :run

FileUtils.mkdir_p 'log' unless File.exists?('log')
log = File.new("log/app.log", "a")
$stdout.reopen(log)
$stderr.reopen(log)

run App #Sinatra::Application
