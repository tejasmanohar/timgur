### Gems
require 'orchestrate'
require 'sinatra'
require 'twilio-ruby'


### API Clients
app = Orchestrate::Application.new(ENV['ORCHESTRATE_API_KEY'])
subscribers = app[:subscribers]
client = Orchestrate::Client.new(ENV['ORCHESTRATE_API_KEY'])


### Configure Twilio
Twilio.configure do |config|
  config.account_sid = ENV['TWILIO_ACCOUNT_SID']
  config.auth_token = ENV['TWILIO_AUTH_TOKEN']
end


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

get '/receive' do
  @twil = Twilio::REST::Client.new
  if params[:Body].eql? 'unsubscribe'
    status 200
    num = format_number(params[:From])
    doc = client.get(:subscribers, num)
    client.delete(:subscribers, num, doc.ref)
    @twil.messages.create(
      from: ENV['TWILIO_NUMBER'],
      to: params[:From],
      body: 'You are now unsubscribed.'
    )
  else
    status 400
  end
end
