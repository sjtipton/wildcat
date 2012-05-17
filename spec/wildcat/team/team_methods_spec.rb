require "spec_helper"
require 'support/hydra_spec_helper'
include HydraSpecHelper

describe Wildcat::Team do

  describe "Wildcat::Team.find" do

    before do
      @attr = FactoryGirl.attributes_for(:team)
      stub_hydra
    end

    it "should respond to find" do
      Wildcat::Team.should respond_to(:find)
    end

    context "when present on ProFootballApi" do

      before do
        team = Wildcat::Team.new(@attr)
        stub_for_show_team(team)
      end

      after do
        clear_get_stubs
      end

      it "should return a Wildcat::Team" do
        @team = nil
        Wildcat::Team.find(@attr[:id]) do |team|
          @team = team
        end

        Wildcat::Config.hydra.run
        @team.should be_a(Wildcat::Team)
      end
    end

    context "when not found on ProFootballApi" do

      before do
        @id = SecureRandom.random_number(1e9.to_i)
        response_hash = { code: 404,
                          body: { code: 404,
                           description: "Resource not found",
                                errors: [{id: @id.to_s}] }.to_json }
        stub_for_get_url("#{Wildcat::Config.base_url}/teams/#{@id}?" +
                         "auth_token=#{Wildcat::Config.auth_token}", response_hash)
      end

      it "should raise a Wildcat::ResourceNotFound error" do
        expect { Wildcat::Team.find(@id) do |result|
                   @result = result
                 end
                 Wildcat::Config.hydra.run }.to raise_error(Wildcat::ResourceNotFound)
      end

      it "should raise the correct Wildcat::ResourceNotFound error" do
        begin
          Wildcat::Team.find(@id) do |result|
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
        stub_for_get_url("#{Wildcat::Config.base_url}/teams/#{@attr[:id]}?" +
                         "auth_token=#{Wildcat::Config.auth_token}", response_hash)
      end

      it "should raise a Wildcat::UnauthorizedAccess error" do
        expect { Wildcat::Team.find(@attr[:id]) do |result|
                   @result = result
                 end
                 Wildcat::Config.hydra.run }.to raise_error(Wildcat::UnauthorizedAccess)
      end

      it "should raise the correct Wildcat::UnauthorizedAccess error" do
        begin
          Wildcat::Team.find(@attr[:id]) do |result|
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
        stub_for_get_url("#{Wildcat::Config.base_url}/teams/#{@attr[:id]}?" +
                         "auth_token=#{Wildcat::Config.auth_token}", response_hash)
      end

      it "should raise a Wildcat::ServiceUnavailable error" do
        expect { Wildcat::Team.find(@attr[:id]) do |result|
                   @result = result
                 end
                 Wildcat::Config.hydra.run }.to raise_error(Wildcat::ServiceUnavailable)
      end

      it "should raise the correct Wildcat::ServiceUnavailable error" do
        begin
          Wildcat::Team.find(@attr[:id]) do |result|
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
        stub_for_get_url("#{Wildcat::Config.base_url}/teams/#{@attr[:id]}?" +
                         "auth_token=#{Wildcat::Config.auth_token}", response_hash)
      end

      it "should raise a Wildcat::Error" do
        expect { Wildcat::Team.find(@attr[:id]) do |result|
                   @result = result
                 end
                 Wildcat::Config.hydra.run }.to raise_error(Wildcat::Error)
      end

      it "should raise the correct Wildcat::Error" do
        begin
          Wildcat::Team.find(@attr[:id]) do |result|
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

  describe "Wildcat::Team.all" do

    before do
      stub_hydra
    end

    after do
      clear_get_stubs
    end

    it "should respond to 'all'" do
      Wildcat::Team.should respond_to('all')
    end

    context "when present on ProFootballApi" do

      before do
        @teams = []
        3.times { @teams << FactoryGirl.build(:team) }
        stub_for_team_index(@teams)
      end

      after do
        clear_get_stubs
      end

      it "should return an array of teams" do
        @result = nil

        Wildcat::Team.all do |teams|
          @result = teams
        end
        Wildcat::Config.hydra.run

        @result.should_not be_nil
        @result.should be_an(Array)
        @result.first.should be_a(Wildcat::Team)
        @result.first.attributes.should eq(@teams.first.attributes)
      end
    end

    context "when not authorized" do

      before do
        response_hash = { code: 401,
                          body: {error: "Invalid authentication token."}.to_json }
        stub_for_get_url("#{Wildcat::Config.base_url}/teams?" +
                         "auth_token=#{Wildcat::Config.auth_token}", response_hash)
      end

      it "should raise a Wildcat::UnauthorizedAccess error" do
        expect { Wildcat::Team.all do |result|
                   @result = result
                 end
                 Wildcat::Config.hydra.run }.to raise_error(Wildcat::UnauthorizedAccess)
      end

      it "should raise the correct Wildcat::UnauthorizedAccess error" do
        begin
          Wildcat::Team.all do |result|
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
        stub_for_get_url("#{Wildcat::Config.base_url}/teams?" +
                         "auth_token=#{Wildcat::Config.auth_token}", response_hash)
      end

      it "should raise a Wildcat::ServiceUnavailable error" do
        expect { Wildcat::Team.all do |result|
                   @result = result
                 end
                 Wildcat::Config.hydra.run }.to raise_error(Wildcat::ServiceUnavailable)
      end

      it "should raise the correct Wildcat::ServiceUnavailable error" do
        begin
          Wildcat::Team.all do |result|
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
        stub_for_get_url("#{Wildcat::Config.base_url}/teams?" +
                         "auth_token=#{Wildcat::Config.auth_token}", response_hash)
      end

      it "should raise a Wildcat::Error" do
        expect { Wildcat::Team.all do |result|
                   @result = result
                 end
                 Wildcat::Config.hydra.run }.to raise_error(Wildcat::Error)
      end

      it "should raise the correct Wildcat::Error" do
        begin
          Wildcat::Team.all do |result|
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
