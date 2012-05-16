require 'spec_helper'

describe Wildcat::Team do

  describe "attributes" do

    it { should respond_to(:id) }
    it { should respond_to(:name) }
    it { should respond_to(:nickname) }
    it { should respond_to(:abbreviation) }
    it { should respond_to(:location) }
    it { should respond_to(:conference) }
    it { should respond_to(:division) }
  end
end
