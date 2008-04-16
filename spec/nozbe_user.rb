require File.dirname(__FILE__) + "/spec_helper"

describe Nozbe::User do
  include NozbeSpecHelper
  
  before(:all) do
    @user = Nozbe::User.new(user_email, user_password)
  end
  
  it "should not be logged in if no user_key provided" do
    @user.logged_in?.should eql(false)
  end
  
  it "should login successfully" do
    @user.login.should eql(user_key)
    @user.logged_in?.should eql(true)
    @user.key.should eql(user_key)
  end
  
end