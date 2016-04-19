require 'rspec'
require 'rack/test'
require 'pathname'

require Pathname(Dir.pwd).join 'lib', 'exchanger'
require Pathname(Dir.pwd).join 'app'

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure { |c| c.include RSpecMixin }
