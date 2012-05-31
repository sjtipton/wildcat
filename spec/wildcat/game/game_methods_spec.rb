require "spec_helper"
require 'support/hydra_spec_helper'
include HydraSpecHelper

describe Wildcat::Game do

  describe "Wildcat::Game.find" do

    before do
      @attr = FactoryGirl.attributes_for(:game)
      stub_hydra
    end

    it "should respond to find" do
      Wildcat::Game.should respond_to(:find)
    end

    context "when present on ProFootballApi" do

      before do
        game = Wildcat::Game.new(@attr)
        stub_for_show_game(game)
      end

      after do
        clear_get_stubs
      end

      it "should return a Wildcat::Game" do
        @game = nil
        Wildcat::Game.find(@attr[:id]) do |game|
          @game = game
        end

        Wildcat::Config.hydra.run
        @game.should be_a(Wildcat::Game)
      end

      it "should return played_at as a valid Time" do
        @result = nil
        Wildcat::Game.find(@attr[:id]){ |game| @result = game }
        Wildcat::Config.hydra.run

        @result.played_at.should be_a(Time)
      end
    end

    context "when not found on ProFootballApi" do

      before do
        @id = SecureRandom.random_number(1e9.to_i)
        response_hash = { code: 404,
                          body: { code: 404,
                           description: "Resource not found",
                                errors: [{id: @id.to_s}] }.to_json }
        stub_for_get_url("#{Wildcat::Config.base_url}/games/#{@id}?" +
                         "auth_token=#{Wildcat::Config.auth_token}", response_hash)
      end

      it "should raise a Wildcat::ResourceNotFound error" do
        expect { Wildcat::Game.find(@id) do |result|
                   @result = result
                 end
                 Wildcat::Config.hydra.run }.to raise_error(Wildcat::ResourceNotFound)
      end

      it "should raise the correct Wildcat::ResourceNotFound error" do
        begin
          Wildcat::Game.find(@id) do |result|
            @result = result
          end
          Wildcat::Config.hydra.run
        rescue Wildcat::ResourceNotFound => e
          e.message.should eq("Resource not found")
          e.status.should eq(404)
          e.errors.should include({ id: @id.to_s })
        end
      end
    end

    context "when not authorized" do

      before do
        response_hash = { code: 401,
                          body: {error: "Invalid authentication token."}.to_json }
        stub_for_get_url("#{Wildcat::Config.base_url}/games/#{@attr[:id]}?" +
                         "auth_token=#{Wildcat::Config.auth_token}", response_hash)
      end

      it "should raise a Wildcat::UnauthorizedAccess error" do
        expect { Wildcat::Game.find(@attr[:id]) do |result|
                   @result = result
                 end
                 Wildcat::Config.hydra.run }.to raise_error(Wildcat::UnauthorizedAccess)
      end

      it "should raise the correct Wildcat::UnauthorizedAccess error" do
        begin
          Wildcat::Game.find(@attr[:id]) do |result|
            @result = result
          end
          Wildcat::Config.hydra.run
        rescue Wildcat::UnauthorizedAccess => e
          e.message.should eq("You need to sign in or sign up before continuing.")
          e.status.should eq(401)
          e.errors.should include({ error: "Invalid authentication token." })
        end
      end
    end

    context "when a 503 is returned" do

      before do
        response_hash = { code: 503,
                          body: "We're sorry but something went wrong." }
        stub_for_get_url("#{Wildcat::Config.base_url}/games/#{@attr[:id]}?" +
                         "auth_token=#{Wildcat::Config.auth_token}", response_hash)
      end

      it "should raise a Wildcat::ServiceUnavailable error" do
        expect { Wildcat::Game.find(@attr[:id]) do |result|
                   @result = result
                 end
                 Wildcat::Config.hydra.run }.to raise_error(Wildcat::ServiceUnavailable)
      end

      it "should raise the correct Wildcat::ServiceUnavailable error" do
        begin
          Wildcat::Game.find(@attr[:id]) do |result|
            @result = result
          end
          Wildcat::Config.hydra.run
        rescue Wildcat::ServiceUnavailable => e
          e.message.should eq("Service unavailable.")
          e.status.should eq(503)
          e.errors.should include({ error: "We're sorry but something went wrong." })
        end
      end
    end

    context "when no code is returned" do

      before do
        response_hash = { code: 0,
                          body: "",
                          curl_error_message: "bad request" }
        stub_for_get_url("#{Wildcat::Config.base_url}/games/#{@attr[:id]}?" +
                         "auth_token=#{Wildcat::Config.auth_token}", response_hash)
      end

      it "should raise a Wildcat::Error" do
        expect { Wildcat::Game.find(@attr[:id]) do |result|
                   @result = result
                 end
                 Wildcat::Config.hydra.run }.to raise_error(Wildcat::Error)
      end

      it "should raise the correct Wildcat::Error" do
        begin
          Wildcat::Game.find(@attr[:id]) do |result|
            @result = result
          end
          Wildcat::Config.hydra.run
        rescue Wildcat::Error => e
          e.message.should eq("Unknown error.")
          e.status.should eq(0)
          e.errors.should include({ error: "bad request" })
        end
      end
    end
  end

  describe "Wildcat::Game.all" do

    before do
      stub_hydra
    end

    after do
      clear_get_stubs
    end

    it "should respond to 'all'" do
      Wildcat::Game.should respond_to('all')
    end

    context "when present on ProFootballApi" do

      before do
        @games = []
        3.times { @games << FactoryGirl.build(:game) }
        stub_for_game_index(@games)
      end

      after do
        clear_get_stubs
      end

      it "should return an array of games" do
        @result = nil

        Wildcat::Game.all do |games|
          @result = games
        end
        Wildcat::Config.hydra.run

        @result.should_not be_nil
        @result.should be_an(Array)
        @result.first.should be_a(Wildcat::Game)
        @result.first.id.should eq(@games.first.id)
      end

      it "should return played_at as a valid Time" do
        @result = nil
        Wildcat::Game.all { |games| @result = games }
        Wildcat::Config.hydra.run

        @result.first.played_at.should be_a(Time)
      end
    end

    context "when not authorized" do

      before do
        response_hash = { code: 401,
                          body: {error: "Invalid authentication token."}.to_json }
        stub_for_get_url("#{Wildcat::Config.base_url}/games?" +
                         "auth_token=#{Wildcat::Config.auth_token}", response_hash)
      end

      it "should raise a Wildcat::UnauthorizedAccess error" do
        expect { Wildcat::Game.all do |result|
                   @result = result
                 end
                 Wildcat::Config.hydra.run }.to raise_error(Wildcat::UnauthorizedAccess)
      end

      it "should raise the correct Wildcat::UnauthorizedAccess error" do
        begin
          Wildcat::Game.all do |result|
            @result = result
          end
          Wildcat::Config.hydra.run
        rescue Wildcat::UnauthorizedAccess => e
          e.message.should eq("You need to sign in or sign up before continuing.")
          e.status.should eq(401)
          e.errors.should include({ error: "Invalid authentication token." })
        end
      end
    end

    context "when a 503 is returned" do

      before do
        response_hash = { code: 503,
                          body: "We're sorry but something went wrong." }
        stub_for_get_url("#{Wildcat::Config.base_url}/games?" +
                         "auth_token=#{Wildcat::Config.auth_token}", response_hash)
      end

      it "should raise a Wildcat::ServiceUnavailable error" do
        expect { Wildcat::Game.all do |result|
                   @result = result
                 end
                 Wildcat::Config.hydra.run }.to raise_error(Wildcat::ServiceUnavailable)
      end

      it "should raise the correct Wildcat::ServiceUnavailable error" do
        begin
          Wildcat::Game.all do |result|
            @result = result
          end
          Wildcat::Config.hydra.run
        rescue Wildcat::ServiceUnavailable => e
          e.message.should eq("Service unavailable.")
          e.status.should eq(503)
          e.errors.should include({ error: "We're sorry but something went wrong." })
        end
      end
    end

    context "when no code is returned" do

      before do
        response_hash = { code: 0,
                          body: "",
                          curl_error_message: "bad request" }
        stub_for_get_url("#{Wildcat::Config.base_url}/games?" +
                         "auth_token=#{Wildcat::Config.auth_token}", response_hash)
      end

      it "should raise a Wildcat::Error" do
        expect { Wildcat::Game.all do |result|
                   @result = result
                 end
                 Wildcat::Config.hydra.run }.to raise_error(Wildcat::Error)
      end

      it "should raise the correct Wildcat::Error" do
        begin
          Wildcat::Game.all do |result|
            @result = result
          end
          Wildcat::Config.hydra.run
        rescue Wildcat::Error => e
          e.message.should eq("Unknown error.")
          e.status.should eq(0)
          e.errors.should include({ error: "bad request" })
        end
      end
    end
  end

  describe "Wildcat::Game.find_by_team" do

    before do
      stub_hydra

      @teams, @games = [], []
      names = [ "Carolina Panthers",
                "Seattle Seahawks",
                "Baltimore Ravens",
                "San Diego Chargers",
                "Dallas Cowboys",
                "San Francisco 49ers" ]
      names.each do |n|
        @teams << FactoryGirl.build(:team, name: n)
      end
      @games << FactoryGirl.build(:game, home_team_id: @teams.first.id,
                                         away_team_id: @teams[1].id)
      @games << FactoryGirl.build(:game, home_team_id: @teams[3].id,
                                         away_team_id: @teams[4].id)
      @games << FactoryGirl.build(:game, home_team_id: @teams.last.id,
                                         away_team_id: @teams[2].id)
    end

    after do
      clear_get_stubs
    end

    it "should respond to 'find_by_team'" do
      Wildcat::Game.should respond_to('find_by_team')
    end

    context "when valid" do

      before do
        stub_for_team_game_index(@games)
      end

      after do
        clear_get_stubs
      end

      it "should return an array of games for the specified team" do
        @result = nil

        Wildcat::Game.find_by_team(@teams.first.id) do |games|
          @result = games
        end
        Wildcat::Config.hydra.run

        @result.should_not be_nil
        @result.should be_an(Array)
        @result.first.should be_a(Wildcat::Game)
        @result.first.home_team_id.should eq(@teams.first.id)
        @result.first.away_team_id.should eq(@teams[1].id)
      end

      it "should return played_at as a valid Time" do
        @result = nil
        Wildcat::Game.find_by_team(@teams.first.id) { |games| @result = games }
        Wildcat::Config.hydra.run

        @result.first.played_at.should be_a(Time)
      end
    end

    context "when not authorized" do

      before do
        response_hash = { code: 401,
                          body: {error: "Invalid authentication token."}.to_json }
        stub_for_get_url("#{Wildcat::Config.base_url}/teams/#{@teams.first.id}/games?" +
                         "auth_token=#{Wildcat::Config.auth_token}", response_hash)
      end

      it "should raise a Wildcat::UnauthorizedAccess error" do
        expect { Wildcat::Game.find_by_team(@teams.first.id) do |result|
                   @result = result
                 end
                 Wildcat::Config.hydra.run }.to raise_error(Wildcat::UnauthorizedAccess)
      end

      it "should raise the correct Wildcat::UnauthorizedAccess error" do
        begin
          Wildcat::Game.find_by_team(@teams.first.id) do |result|
            @result = result
          end
          Wildcat::Config.hydra.run
        rescue Wildcat::UnauthorizedAccess => e
          e.message.should eq("You need to sign in or sign up before continuing.")
          e.status.should eq(401)
          e.errors.should include({ error: "Invalid authentication token." })
        end
      end
    end

    context "when a 503 is returned" do

      before do
        response_hash = { code: 503,
                          body: "We're sorry but something went wrong." }
        stub_for_get_url("#{Wildcat::Config.base_url}/teams/#{@teams.first.id}/games?" +
                         "auth_token=#{Wildcat::Config.auth_token}", response_hash)
      end

      it "should raise a Wildcat::ServiceUnavailable error" do
        expect { Wildcat::Game.find_by_team(@teams.first.id) do |result|
                   @result = result
                 end
                 Wildcat::Config.hydra.run }.to raise_error(Wildcat::ServiceUnavailable)
      end

      it "should raise the correct Wildcat::ServiceUnavailable error" do
        begin
          Wildcat::Game.find_by_team(@teams.first.id) do |result|
            @result = result
          end
          Wildcat::Config.hydra.run
        rescue Wildcat::ServiceUnavailable => e
          e.message.should eq("Service unavailable.")
          e.status.should eq(503)
          e.errors.should include({ error: "We're sorry but something went wrong." })
        end
      end
    end

    context "when no code is returned" do

      before do
        response_hash = { code: 0,
                          body: "",
                          curl_error_message: "bad request" }
        stub_for_get_url("#{Wildcat::Config.base_url}/teams/#{@teams.first.id}/games?" +
                         "auth_token=#{Wildcat::Config.auth_token}", response_hash)
      end

      it "should raise a Wildcat::Error" do
        expect { Wildcat::Game.find_by_team(@teams.first.id) do |result|
                   @result = result
                 end
                 Wildcat::Config.hydra.run }.to raise_error(Wildcat::Error)
      end

      it "should raise the correct Wildcat::Error" do
        begin
          Wildcat::Game.find_by_team(@teams.first.id) do |result|
            @result = result
          end
          Wildcat::Config.hydra.run
        rescue Wildcat::Error => e
          e.message.should eq("Unknown error.")
          e.status.should eq(0)
          e.errors.should include({ error: "bad request" })
        end
      end
    end
  end
end
