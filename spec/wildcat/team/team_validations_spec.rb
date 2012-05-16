require 'spec_helper'

describe Wildcat::Team do

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:nickname) }
  it { should validate_presence_of(:abbreviation) }
  it { should validate_presence_of(:location) }
  it { should validate_presence_of(:conference) }
  it { should validate_presence_of(:division) }
end
