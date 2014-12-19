### Gems
require 'imgur'
require 'orchestrate'
require 'sinatra'

### Environments
configure :development do
  require 'pry'
  require 'sinatra/reloader'
end

### API Clients
app = Orchestrate::Application.new(ENV['API_KEY'])
users = app[:users]
client = Orchestrate::Client.new(ENV['API_KEY'])

### Routes
get '/' do
  erb :home
end
