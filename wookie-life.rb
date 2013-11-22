require 'sinatra'
require 'sinatra/auth/github'
require 'haml'
require 'rest-client'

module WookieLife
  class WookieLifeApp < Sinatra::Base
    CLIENT_ID = ENV['GH_BASIC_CLIENT_ID']
    CLIENT_SECRET = ENV['GH_BASIC_SECRET_ID']

    enable :sessions

    set :github_options, {
      :scopes       => "user",
      :secret       => CLIENT_SECRET,
      :client_id    => CLIENT_ID,
      :callback_url => "/callback"
    }

    register Sinatra::Auth::Github

    get '/' do 
    	redirect '/de'
    end

    get '/de' do
      if !authenticated?
        haml :home, :locals => {:client_id => CLIENT_ID}
      else
        access_token = github_user["token"]
        auth_result = RestClient.get("https://api.github.com/user", {:params => {:access_token => access_token, :accept => :json},
                                                                                   :accept => :json})
        auth_result = JSON.parse(auth_result)

    	 haml :home, :locals => { :login => auth_result["login"] }
      end
    end

    get '/callback' do
      if authenticated?
        redirect "/de"
      else
        authenticate!
      end
    end
  end
end
