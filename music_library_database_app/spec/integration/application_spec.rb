require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "GET request to /albums/last" do
    it "gets the last album title" do
      response = get("/albums/last")

      expect(response.status).to eq 200
      expect(response.body).to eq "Ring Ring"
    end
  end
  
  context "POST request to /albums" do
    it "finds newly posted album data at the end of album list" do
      response = post("/albums", title:"Flying in a Blue Dream", release_year:1989, artist_id:5)
      
      expect(response.status).to eq 200
      expect(resonse.body).to eq ""
      last_album = get("/albums/last")
      expect(last_album.status).to eq 200
      expect(last_album.body).to eq "Flying in a Blue Dream"
    end
  end
end
