require File.dirname(__FILE__) + "/spec_helper"

describe Nozbe::Project do
  include NozbeSpecHelper
  
  before(:all) do
    @project = Nozbe::Project.list(user_key).first
  end
  
  it "should list all projects" do
    projects = Nozbe::Project.list(user_key)
    projects.class.should eql(Array)
    projects.first.class.should eql(Nozbe::Project)
  end
  
  it "should load its info" do
    @project = @project.load_info(user_key)
    @project.class.should eql(Nozbe::Project)
    @project.body.should_not eql(nil)
  end
  
  it "should get all associated actions" do
    actions = @project.get_actions(user_key)
    actions.class.should eql(Array)
    actions.first.class.should eql(Nozbe::Action)
  end
  
  it "should get all associated notes" do
    notes = @project.get_notes(user_key)
    notes.class.should eql(Array)
    notes.first.class.should eql(Nozbe::Note)
  end
  
  it "should save itself" do
    new_project = Nozbe::Project.new()
    new_project.name = "new project"
    new_project.body = "This is a test of a new project !"
    new_project.save!(user_key).class.should eql(Nozbe::Project)
  end
  
end