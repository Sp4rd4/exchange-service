require 'sinatra'
require 'sinatra/config_file'
require 'sinatra/json'
require 'json'
require_relative 'lib/exchanger'

set :server, 'thin'

config_file 'config.yml'
exchanger = Exchanger.new(settings.coins)

def transform_input(hash)
  hash.each_with_object({}) do |(k, v), h|
    h[k.to_i] = v.to_i if k.respond_to?(:to_i) && v.respond_to?(:to_i)
  end
end

get '/' do
  json exchanger.coins
end

get '/exchange' do
  amount = params[:amount].to_i
  json exchanger.exchange(amount)
end

post '/add' do
  payload = request.body.read
  input =
    if payload.empty?
      {}
    else
      transform_input(JSON.parse(payload))
    end
  if input.empty?
    status 400
    return json message: 'Bad data'
  end
  exchanger.add(input)
  json exchanger.coins
end

error ExchangeError do
  status 418
  json message: env['sinatra.error'].message
end
