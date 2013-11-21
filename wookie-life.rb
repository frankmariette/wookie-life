require 'sinatra'
require 'haml'
require 'rest-client'

CLIENT_ID = ENV['GH_BASIC_CLIENT_ID']
CLIENT_SECRET = ENV['GH_BASIC_SECRET_ID']

get '/' do 
	erb :index, :locals => { :client_id => CLIENT_ID }
end

get '/de' do
	haml :index
end

get '/callback' do
  # get temporary GitHub code...
  session_code = request.env['rack.request.query_hash']["code"]
  # ... and POST it back to GitHub
  result = RestClient.post("https://github.com/login/oauth/access_token",
                          {:client_id => CLIENT_ID,
                           :client_secret => CLIENT_SECRET,
                           :code => session_code
                           },{
                            :accept => :json
                            })
  access_token = JSON.parse(result){"access_token"}
end

get '/basic' do
  auth_result = RestClient.get("https://api.github.com/user", {:params => {:access_token => access_token}})

  erb :basic, :locals => {:auth_result => auth_result}
end