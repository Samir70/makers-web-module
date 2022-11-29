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

  describe "album routes" do
    before(:each) do
      reset_albums_table
    end
    context "GET request to /albums/last" do
      it "gets the last album title" do
        response = get("/albums/last")

        expect(response.status).to eq 200
        expect(response.body).to eq "Ring Ring"
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
        expect(response.body).to include("Pixies").exactly(3).times
      end
    end

    context "POST request to /albums" do
      it "finds newly posted album data at the end of album list" do
        response = post("/albums", title: "Flying in a Blue Dream", release_year: 1989, artist_id: 5)

        expect(response.status).to eq 200
        expect(response.body).to eq ""
        last_album = get("/albums/last")
        expect(last_album.status).to eq 200
        expect(last_album.body).to eq "Flying in a Blue Dream"
      end
    end
  end

  describe "Artist routes" do
    before(:each) do
      reset_artists_table
    end
    context "GET /artists" do
      it "returns a list of artists" do
        response = get("/artists")

        expect(response.status).to eq 200
        expect(response.body).to eq "Pixies, ABBA, Taylor Swift, Nina Simone"
      end
    end
  end
end
