require File.dirname(__FILE__) + "/spec_helper"

describe Nozbe::Context do
  include NozbeSpecHelper
  
  before(:all) do
    @context = Nozbe::Context.list(user_key).first
  end
  
  it "should get a default context" do
    default_context = Nozbe::Context.get_default_context(user_key)
    default_context.class.should eql(Nozbe::Context)
  end
  
  it "should get a context from its name" do
    context_name = 'Mail'
    context = Nozbe::Context.get_from_name(user_key, context_name)
    context.class.should eql(Nozbe::Context)
    context.name.downcase.should eql(context_name.downcase)
  end
  
  it "should return nil when trying to get a context from its name when the name doesn't exists" do
    context = Nozbe::Context.get_from_name(user_key, 'unknown and non existant context name')
    context.should eql(nil)
  end
  
  it "should return nil when trying to get a context from its name with a nil name" do
    context = Nozbe::Context.get_from_name(user_key, nil)
    context.should eql(nil)
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
    actions.first.context.should eql(@context)
  end
  
  it "should get all associated notes" do
    notes = @context.get_notes(user_key)
    notes.class.should eql(Array)
    notes.first.class.should eql(Nozbe::Note)
    notes.first.context.should eql(@context)
  end
  
end