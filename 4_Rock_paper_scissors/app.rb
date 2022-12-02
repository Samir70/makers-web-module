require 'sinatra/base'
require 'sinatra/reloader'
require_relative './lib/rock_paper_scissors'

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end

  get "/" do
    @choice = params[:choice] || ["Rock", "Paper", "Scissors"].sample
    return erb(:homepage)
  end

  post "/results" do
    @user = params[:user_choice]
    @comp = params[:comp_choice]
    comp_rps = RockPaperScissors.new(params[:comp_choice])
    @result = comp_rps.compare(@user)
    return erb(:results_page)
  end
end