require 'spec_helper'

describe Wildcat::Game do

  describe "attributes" do

    it { should respond_to(:id) }
    it { should respond_to(:away_team_id) }
    it { should respond_to(:home_team_id) }
    it { should respond_to(:label) }
    it { should respond_to(:played_at) }
    it { should respond_to(:season) }
    it { should respond_to(:stadium) }
    it { should respond_to(:week) }
  end
end
