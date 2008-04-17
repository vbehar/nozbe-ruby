require File.dirname(__FILE__) + "/spec_helper"

describe Nozbe::Action do
  include NozbeSpecHelper
  
  before(:all) do
    @action = Nozbe::Action.list_next(user_key).first
  end
  
  it "should list all actions" do
    actions = Nozbe::Action.list(user_key)
    actions.class.should eql(Array)
    actions.first.class.should eql(Nozbe::Action)
  end
  
  it "should list all next actions" do
    actions = Nozbe::Action.list_next(user_key)
    actions.class.should eql(Array)
    actions.first.class.should eql(Nozbe::Action)
  end
  
  it "should check many actions at once" do
    actions = Nozbe::Action.list_next(user_key)
    Nozbe::Action.done!(user_key, actions).should eql(true)
  end
  
  it "should check itself" do
    @action.done!(user_key).should eql(true)
  end
  
  it "should save itself" do
    new_action = Nozbe::Action.new()
    new_action.name = "new action"
    new_action.project = @action.project
    new_action.context = @action.context
    new_action.time = 5
    new_action.next = true
    new_action.save!(user_key).class.should eql(Nozbe::Action)
  end
  
end