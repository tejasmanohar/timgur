# require 'ruby-imgur'
require 'orchestrate'
require 'sinatra'

configure :development do
  require 'pry'
  require 'sinatra/reloader'
end

get '/' do
  erb :home
end
