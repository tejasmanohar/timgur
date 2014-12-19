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
subscribers = app[:subscribers]
client = Orchestrate::Client.new(ENV['API_KEY'])

### Routes
get '/' do
  status 200
  erb :home
end

post '/subscribe' do
  if subscribers[params[:number]].nil?
    status 200
    subscribers.create(params[:number], { '' => '' })
  else
    status 400
    'already subscribed'
  end
end
