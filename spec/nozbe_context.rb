require File.dirname(__FILE__) + "/spec_helper"

describe Nozbe::Context do
  include NozbeSpecHelper
  
  before(:all) do
    @context = Nozbe::Context.list(user_key).first
  end
  
  it "should list all contexts" do
    contexts = Nozbe::Context.list(user_key)
    contexts.class.should eql(Array)
    contexts.first.class.should eql(Nozbe::Context)
  end
  
  it "should load its info" do
    @context = @context.load_info(user_key)
    @context.class.should eql(Nozbe::Context)
    @context.body.should_not eql(nil)
  end
  
  it "should get all associated actions" do
    actions = @context.get_actions(user_key)
    actions.class.should eql(Array)
    actions.first.class.should eql(Nozbe::Action)
  end
  
  it "should get all associated notes" do
    notes = @context.get_notes(user_key)
    notes.class.should eql(Array)
    notes.first.class.should eql(Nozbe::Note)
  end
  
end