#let Bundler handle all requires
require 'bundler'
Bundler.require(:default)

# register your app at facebook to get those infos
# your app id
APP_ID     = 943285442420441
# your app secret
APP_SECRET = 'a78b92d6e3e4066c5eb72aba55ab70c1'

class SimpleRubyFacebookExample < Sinatra::Application

  use Rack::Session::Cookie, secret: 'ecedf672c505425f5e843490865674727f71194ee5ed2960908b4a81735a1bc86a21ef94c898b2b626c66fa1d0b2874b4d42a4c06b300e14098ceb1dcee7bbc5'

  before do
    @logged = session["access_token"] != nil
  end

  get '/' do
    if session['access_token']
      @graph = Koala::Facebook::API.new(session["access_token"])
      @profile = @graph.get_connections("me", "friends")
      # 'You are logged in! <a href="/logout">Logout</a>'
      slim :index
      # do some stuff with facebook here
      # for example:
      # @graph = Koala::Facebook::API.new(session["access_token"])
      # p @graph.get_object("me")
      # publish to your wall (if you have the permissions)
      # @graph.put_wall_post("I'm posting from my new cool app!")
      # or publish to someone else (if you have the permissions too ;) )
      # @graph.put_wall_post("Checkout my new cool app!", {}, "someoneelse's id")
    else
      '<a href="/login">Login</a>'
    end
  end

  get '/login' do
    # generate a new oauth object with your app data and your callback url
    session['oauth'] = Koala::Facebook::OAuth.new(APP_ID, APP_SECRET, "#{request.base_url}/callback")
    # redirect to facebook to get your code
    redirect session['oauth'].url_for_oauth_code()
  end

  get '/logout' do
    session['oauth'] = nil
    session['access_token'] = nil
    redirect '/'
  end

  #method to handle the redirect from facebook back to you
  get '/callback' do
    #get the access token from facebook with your code
    session['access_token'] = session['oauth'].get_access_token(params[:code])
    redirect '/'
  end
end

