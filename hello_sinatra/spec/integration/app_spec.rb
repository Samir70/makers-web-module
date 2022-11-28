# file: spec/integration/application_spec.rb

require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "GET to /hello" do
    it "returns 200 OK with the right content" do
      # Send a GET request to /
      # and returns a response object we can test.
      response = get("/hello?name=Samir")

      # Assert the response status code and body.
      expect(response.status).to eq(200)
      expect(response.body).to eq("Hello, Samir!")
    end
  end

  context "Get to /names" do
    it "returns 200 OK with a list of names" do
        response = get("/names")
        expect(response.status).to eq 200
        expect(response.body).to eq "John, Paul, George and Ringo"
    end
  end

  context "POST to /hello" do
    it "returns 200 OK with the right content" do
      response = post("/hello", name: "Samir", message: "Attack at dawn!")

      # Assert the response status code and body.
      expect(response.status).to eq(200)
      expect(response.body).to eq("Thank you Samir, I have received your message: Attack at dawn!")
    end
  end
  context "POST to /sort-names" do
    it "returns 200 OK with the right content" do
      response = post("/sort-names", names: "John,Paul,George,Ringo")

      # Assert the response status code and body.
      expect(response.status).to eq(200)
      expect(response.body).to eq("George,John,Paul,Ringo")
    end
  end
end