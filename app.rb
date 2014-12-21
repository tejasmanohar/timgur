### Gems
require 'orchestrate'
require 'sinatra'
require 'twilio'

### API Clients
app = Orchestrate::Application.new(ENV['ORCHESTRATE_API_KEY'])
subscribers = app[:subscribers]
client = Orchestrate::Client.new(ENV['ORCHESTRATE_API_KEY'])

### Configure Twilio
Twilio.configure do |config|
  config.account_sid = ENV['TWILIO_ACCOUNT_SID']
  config.auth_token = ENV['TWILIO_AUTH_TOKEN']
end

@twil = Twilio::REST::Client.new

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
  num = format_number params[:number].to_s
  if subscribers[num].nil?
    status 200
    subscribers.create(num, {})
    'subscribed'
  else
    status 400
    'already subscribed'
  end
end

get '/unsubscribe' do
  if params[:Body].eql? 'unsubscribe'
    status 200
    doc = client.get(:subscribers, params[:From])
    client.delete(:subscribers, params[:From], doc.ref)
    @twil.messages.create(
      from: ENV['TWILIO_NUMBER'],
      to: params[:From],
      body: 'You are now unsubscribed.'
    )
  else
    status 400
end
