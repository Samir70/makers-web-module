require "sinatra/base"

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get "/" do
    # The erb method takes the view file name (as a Ruby symbol)
    # and reads its content so it can be sent
    # in the response.
    return erb(:index)
  end
end
