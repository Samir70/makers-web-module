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

  get "/albums/new" do
    return erb(:show_new_album_form)
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
    # status = 400
    bad_data = [nil, ""]
    artist_name = params[:artist_name]
    title = params[:title]
    release_year = params[:release_year]

    # Validate
    @error = nil
    if bad_data.include?(artist_name)
      @error = "You should name the artist for this album"
    elsif bad_data.include?(title)
      @error = "You should name the title of this album"
    elsif bad_data.include?(release_year) 
      @error = "Hey..! When was this album released?"
    end
    if @error != nil
      return  400, erb(:show_error)
    end

    release_year = release_year.to_i
    # check if album artist is new
    artist_repo = ArtistRepository.new
    artist = artist_repo.find_by_name(artist_name)
    if artist == nil
      artist = Artist.new(nil, artist_name, '???')
      artist = artist_repo.create(artist)
    end
    album = Album.new(nil, title, release_year, artist.id, artist.name)
    album_repo = AlbumRepository.new
    album_repo.create(album)
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
