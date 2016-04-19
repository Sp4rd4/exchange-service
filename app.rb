require 'sinatra'
require "sinatra/config_file"

set :server, 'thin'

config_file 'config.yml'

get '/' do
  puts settings.coins
  200
end
