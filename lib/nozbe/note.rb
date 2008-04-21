module Nozbe
  # Note class
  # - It is associated with a Project and a Context
  class Note
    attr_accessor :id, :name, :body, :body_show, :date, :project, :context
    
    # List all notes
    # <b>WARNING !</b>
    # The Nozbe-API doesn't provide such a method, so we use multiple API calls :
    # - load all projects
    # - then, for each project, load all notes
    def self.list(user_key)
      Nozbe::Project.list(user_key).inject([]) { |all_notes, project|
        all_notes + project.get_notes(user_key)
      }
    end
    
    # List all notes for the given Project (using its ID)
    def self.list_for_project(user_key, project_id)
      NotesListApiCall.new(user_key, {:what => :project, :id => project_id}).call
    end
    
    # List all notes for the given Context (using its ID)
    def self.list_for_context(user_key, context_id)
      NotesListApiCall.new(user_key, {:what => :context, :id => context_id}).call
    end
    
    # Save the current Note instance
    # - used to create a new note, not to save an already existing but modified note.
    # - return the instance, with its new ID set
    def save!(user_key)
      NoteNewApiCall.new(user_key, self).call
    end
  end
  
  # This class is used internaly by the Note class 
  # to make the API call that list all notes
  class NotesListApiCall < Nozbe::ApiCall
    action :notes
    # Parse the JSON response, and return an Array of Note instances, 
    # or an empty array if no notes are found.
    def parse(json)
      notes = super(json)
      return [] if notes.nil?
      notes.collect do |raw_note|
        note = Note.new
        note.id = raw_note["id"]
        note.name = raw_note["name"]
        note.body = raw_note["body"]
        note.body_show = raw_note["body_show"]
        note.date = raw_note["date"]
        note.project = Nozbe::Project.new
        note.project.id = raw_note["project_id"]
        note.project.name = raw_note["project_name"]
        note.context = Nozbe::Context.new
        note.context.id = raw_note["context_id"]
        note.context.name = raw_note["context_name"]
        note.context.icon = raw_note["context_icon"]
        note
      end
    end
  end
  
  # This class is used internaly by the Note class 
  # to make the API call that create a new note
  class NoteNewApiCall < Nozbe::ApiCall
    action :newnote
    def initialize(user_key, note)
      super(user_key, {
          :name => url_encode(note.name), 
          :body => url_encode(note.body), 
          :project_id => note.project.id, 
          :context_id => note.context.id,})
      @note = note
    end
    # Parse the JSON response, and return the note instance with its ID set
    def parse(json)
      res = super(json)
      @note.id = res["response"]
      @note
    end
  end
  
end