require File.dirname(__FILE__) + "/spec_helper"

describe Nozbe::Note do
  include NozbeSpecHelper
  
  it "should list all notes" do
    notes = Nozbe::Note.list(user_key)
    notes.class.should eql(Array)
    notes.first.class.should eql(Nozbe::Note)
  end
  
  it "should save itself" do
    new_note = Nozbe::Note.new()
    new_note.name = "new note"
    new_note.body = "This is a test of a new note !"
    new_note.project = Nozbe::Project.list(user_key).first
    new_note.context = Nozbe::Context.list(user_key).first
    new_note.save!(user_key).class.should eql(Nozbe::Note)
  end
  
end