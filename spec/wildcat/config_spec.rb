require "spec_helper"

describe Wildcat::Config do

  it "should respond to host" do
    Wildcat::Config.should respond_to(:host)
  end

  it "should respond to hydra" do
    Wildcat::Config.should respond_to(:hydra)
  end

  it "should respond to auth_token" do
    Wildcat::Config.should respond_to(:auth_token)
  end

  it "should respond to timeout" do
    Wildcat::Config.should respond_to(:timeout)
  end

  it "should respond to protocol" do
    Wildcat::Config.should respond_to(:protocol)
  end

  it "should respond to api_version" do
    Wildcat::Config.should respond_to(:api_version)
  end

  it "should respond to base_url" do
    Wildcat::Config.should respond_to(:base_url)
  end
end
