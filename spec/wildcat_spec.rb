require "spec_helper"

describe Wildcat do

  it "should show the version" do
    Wildcat::VERSION.should_not be_nil
  end
end
