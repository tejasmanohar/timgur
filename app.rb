require 'imgur'
require 'orchestrate'
require 'sinatra'

configure :development do
  require 'pry'
  require 'sinatra/reloader'
end

get '/' do
  erb :home
end

app = Orchestrate::Application.new(ENV['API_KEY'])
users = app[:users]
client = Orchestrate::Client.new(ENV['API_KEY'])
