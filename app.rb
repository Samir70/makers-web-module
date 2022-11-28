require 'sinatra/base'
require 'sinatra/reloader'

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end

  get '/hello' do
    name = params[:name]
    return "Hello, #{name}!"
  end

  get '/names' do
    return "John, Paul, George and Ringo"
  end

  post '/hello' do
    name = params[:name]
    message = params[:message]
    return "Thank you #{name}, I have received your message: #{message}"
  end

  post '/sort-names' do
    names = params[:names]
    return names.split(",").sort.join(",")
  end
end