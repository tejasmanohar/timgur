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
  num = params[:number]
  if Phoner::Phone.valid? num
    if subscribers[num].nil?
      status 200
      subscribers.create(num, { })
    else
      status 400
      'already subscribed'
    end
  end
end
