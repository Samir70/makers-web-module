require "spec_helper"
require "rack/test"
require_relative "../../app"

def reset_albums_table
  seed_sql = File.read("spec/seeds/albums_seeds.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "music_library_test" })
  connection.exec(seed_sql)
end

def reset_artists_table
  seed_sql = File.read("spec/seeds/artists_seeds.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "music_library_test" })
  connection.exec(seed_sql)
end

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }
  before(:each) do
    reset_artists_table
    reset_albums_table
  end

  describe "album routes" do
    context "GET/albums/new" do
      it "returns a form to submit a new album" do
        response = get("/albums/new")

        expect(response.status).to eq 200
        expect(response.body).to include "<html"
        expect(response.body).to include '<form action="/albums" method="POST"'
        expect(response.body).to include '<input type="text" name="title" placeholder="Album title"'
        expect(response.body).to include '<input type="text" name="artist_name" placeholder="artist name"'
        expect(response.body).to include '<input type="text" name="release_year" placeholder="release year"'
        expect(response.body).to include '<input type="submit" value="Submit the form">'
        # expect(response.body).to include '<select name="artist_id"'
        # expect(response.body).to include '<option value="0">Other (provide details)</a>'
        # expect(response.body).to include '<option value="1">ABBA</a>'
        # expect(response.body).to include '<option value="2">Nina Simone</a>'
        # expect(response.body).to include '<option value="3">Pixies</a>'
        # expect(response.body).to include '<option value="4">Taylor Swift</a>'
      end
    end
    context "GET request to /albums/:id" do
      it "returns a correctly formatted page with album info" do
        response = get("/albums/3")

        expect(response.status).to eq 200
        expect(response.body).to include('<span id="album-title">Waterloo</span>')
        expect(response.body).to include('<span id="artist-name">ABBA</span>')
        expect(response.body).to include('<span id="release-year">1974</span>')
      end
    end

    context "GET /albums" do
      it "returns HTML with a list of album data, one album per list item" do
        response = get("/albums")

        expect(response.status).to eq 200
        expect(response.body).to include('<ul id="albums-list"')
        expect(response.body).to include('<li class="album-data">').exactly(12).times
        expect(response.body).to include("Ring Ring")
        expect(response.body).to include("Doolittle")
        expect(response.body).to include("Folklore")
        expect(response.body).to include('<a href="/albums/6">Lover</a>')
        expect(response.body).to include('<a href="/albums/5">Bossanova</a>')
        expect(response.body).to include('<a href="/albums/10">Here Comes the Sun</a>')
      end
    end

    context "POST request to /albums" do
      it "returns an error page if new album data is missing artist name" do
        response = post("/albums", title: "Flying in a Blue Dream", release_year: 1989, artist_id: 1)
        
        expect(response.status).to eq 400
        expect(response.body).to include "ERROR: You should name the artist for this album"
        expect(response.body).to include '<a href="/albums/new">Try again...?</a>'
      end
      it "returns an error page if new album data is missing album title" do
        response = post("/albums", title: "", release_year: 1989, artist_name: "Da Vinci")
        
        expect(response.status).to eq 400
        expect(response.body).to include "ERROR: You should name the title of this album"
        expect(response.body).to include '<a href="/albums/new">Try again...?</a>'
      end
      it "returns an error page if new album data is missing release_year" do
        response = post("/albums", title: "Mona Lisa", artist_name: "Da Vinci")
        
        expect(response.status).to eq 400
        expect(response.body).to include "Hey..! When was this album released?"
        expect(response.body).to include '<a href="/albums/new">Try again...?</a>'
      end
      it "finds newly posted album data in the album list" do
        response = post("/albums", title: "Best of the Pixies", release_year: 1989, artist_name: "Pixies")

        expect(response.status).to eq 200
        expect(response.body).to eq ""
        albums = get("/albums")
        expect(albums.status).to eq 200
        expect(albums.body).to include "Best of the Pixies"
      end
      it "finds newly posted album data in the album list, and new artist in artist list" do
        response = post("/albums", title: "Flying in a Blue Dream", release_year: 1989, artist_name: "Joe Satriani")

        expect(response.status).to eq 200
        expect(response.body).to eq ""
        albums = get("/albums")
        expect(albums.status).to eq 200
        expect(albums.body).to include "Flying in a Blue Dream"
        artists = get("/artists")
        expect(artists.status).to eq 200
        expect(artists.body).to include "Joe Satriani"
      end
    end
  end

  describe "Artist routes" do
    context "GET /artists" do
      it "returns a list of artists" do
        response = get("/artists")

        expect(response.status).to eq 200
        expect(response.body).to include "<html"
        expect(response.body).to include('<a href="/artists/1">Pixies</a>')
        expect(response.body).to include('<a href="/artists/2">ABBA</a>')
        expect(response.body).to include('<a href="/artists/4">Nina Simone</a>')
      end

      it "returns the details of an artist when given an id" do
        response = get("/artists/2")
        expect(response.status).to eq 200
        expect(response.body).to include "<html"
        expect(response.body).to include "<h1>Artist Info Page</h1>"
        expect(response.body).to include "Name: ABBA"
        expect(response.body).to include "Genre: Pop"
      end
    end

    context "POST artists" do
      it "POST /artists" do
        response = post("/artists", name: "Iron Maiden", genre: "Heavy Metal")
        expect(response.status).to eq 200
        expect(response.body).to eq ""

        artists = get("/artists")
        expect(artists.body).to include "Iron Maiden"
      end
    end
  end
end
