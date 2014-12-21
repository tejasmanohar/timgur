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

### Helper Methods
helpers do
  def format_number(number)
    digits = number.gsub(/\D/, '').split(//)

    if (digits.length == 11 and digits[0] == '1')
      # Strip leading 1
      digits.shift
    end

    if (digits.length == 10)
      digits = digits.join
      '(%s) %s-%s' % [ digits[0,3], digits[3,3], digits[6,4] ]
    end
  end
end

### Routes
get '/' do
  status 200
  erb :home
end

post '/subscribe' do
  num = format_number params[:number]
  if subscribers[num].empty?
    status 200
    subscribers.create(num, {})
  else
    status 400
    'already subscribed'
  end
end
