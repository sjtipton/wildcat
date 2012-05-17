require 'spec_helper'

describe Wildcat::Game do

  it { should validate_presence_of(:away_team_id) }
  it { should validate_presence_of(:home_team_id) }
  it { should validate_presence_of(:label) }
  it { should validate_presence_of(:season) }
  it { should validate_presence_of(:stadium) }
end
