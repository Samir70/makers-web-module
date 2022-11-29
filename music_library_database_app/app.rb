# file: app.rb
require "sinatra"
require "sinatra/reloader"
require_relative "lib/database_connection"
require_relative "lib/album_repository"
require_relative "lib/artist_repository"

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload "lib/album_repository"
    also_reload "lib/artist_repository"
  end

  get "/albums/:id" do
    repo = AlbumRepository.new
    album = repo.find(params[:id].to_i)
    @title = album.title
    @artist_name = album.artist_name
    @release_year = album.release_year
    return erb(:show_album)
  end

  get "/albums" do
    repo = AlbumRepository.new
    @albums = repo.all
    return erb(:show_album_list)
  end

  post "/albums" do
    album = Album.new(nil, params[:title], params[:release_year], params[:artist_id])
    repo = AlbumRepository.new
    repo.create(album)
    return ""
  end

  get "/artists" do
    repo = ArtistRepository.new
    @artists = repo.all
    return erb(:show_artist_list)
  end
  get "/artists/:id" do
    repo = ArtistRepository.new
    @artist = repo.find(params[:id].to_i)
    return erb(:show_artist)
  end

  post "/artists" do
    repo = ArtistRepository.new
    artist = Artist.new(nil, params[:name], params[:genre])
    repo.create(artist)
    return ""
  end
end
