require "spec_helper"
require 'support/hydra_spec_helper'
include HydraSpecHelper

describe Wildcat::Game do

  describe "away_team" do

    before do
      @team = FactoryGirl.build(:team)
      @game = FactoryGirl.build(:game, away_team_id: @team.id)
      stub_hydra
    end

    it "should respond to away_team" do
      @game.should respond_to(:away_team)
    end

    context "when valid" do

      before do
        stub_for_show_team(@team)
        stub_for_show_game(@game)
      end

      after { clear_get_stubs }

      it "should return a Wildcat::Team" do
        @game.away_team.should be_a(Wildcat::Team)
        @game.away_team.id.should eq @game.away_team_id
      end
    end
  end
end
