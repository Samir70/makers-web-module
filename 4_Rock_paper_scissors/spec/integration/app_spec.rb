# file: spec/integration/application_spec.rb

require "spec_helper"
require "rack/test"
require_relative "../../app"

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "homepage" do
    it "has a form with a selector with options rock, paper, scissors" do
      response = get("/?choice=Rock")
      expect(response.status).to eq 200
      expect(response.body).to include '<form method="POST" action="/results">'
      expect(response.body).to include '<select name="user_choice">'
      expect(response.body).to include '<option value="Rock">Rock</option>'
      expect(response.body).to include '<option value="Paper">Paper</option>'
      expect(response.body).to include '<option value="Scissors">Scissors</option>'
      expect(response.body).to include "</select>"
      expect(response.body).to include '<input type="hidden" name="comp_choice" value="Rock"'
      expect(response.body).to include '<button type="submit">Confirm</button>'
      expect(response.body).to include "</form>"
    end
  end
  context "results page" do
    it "has a link to the homepage" do
      response = post("/results", user_choice: "Rock", comp_choice: "Paper")
      expect(response.status).to eq 200
      expect(response.body).to include '<a href="/">Play again?</a>'
    end
    it "decides Rock < Paper" do
      response = post("/results", user_choice: "Rock", comp_choice: "Paper")
      expect(response.status).to eq 200
      expect(response.body).to include "You chose Rock"
      expect(response.body).to include "I chose Paper"
      expect(response.body).to include "Paper covers Rock. I win"
    end
    it "decides Paper < Scissors" do
      response = post("/results", user_choice: "Scissors", comp_choice: "Paper")
      expect(response.status).to eq 200
      expect(response.body).to include "You chose Scissors"
      expect(response.body).to include "I chose Paper"
      expect(response.body).to include "Scissors cut Paper. You win"
    end
    it "decides Rock > Scissors" do
      response = post("/results", user_choice: "Scissors", comp_choice: "Rock")
      expect(response.status).to eq 200
      expect(response.body).to include "You chose Scissors"
      expect(response.body).to include "I chose Rock"
      expect(response.body).to include "Rock blunts Scissors. I win"
    end
    it "decides Rock == Rock" do
      response = post("/results", user_choice: "Rock", comp_choice: "Rock")
      expect(response.status).to eq 200
      expect(response.body).to include "You chose Rock"
      expect(response.body).to include "I chose Rock"
      expect(response.body).to include "Rocks smash each other to pieces. We both loose. Why does it have to be like this?!"
    end
  end
end
