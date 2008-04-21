module Nozbe
  # Project class
  # - In Nozbe, a project is used to group Action (or Note) together
  # - The number of projects is limited by the Nozbe-account (for a free account : 5)
  class Project
    DEFAULT_PROJECT_NAME = "Inbox"
    
    attr_accessor :id, :name, :body, :body_show, :count
    
    # return the default Project instance : 
    # the project with its name set to DEFAULT_PROJECT_NAME
    def self.get_default_project(user_key)
      get_from_name(user_key, DEFAULT_PROJECT_NAME)
    end
    
    # return a Project instance from the given project_name
    # - it may return nil if there is no matches
    # <b>WARNING</b> :
    # the Nozbe-API doesn't provide such a method, 
    # so we load all projects and compare the names with the given name
    # - the comparison is case-insensitive (use 'downcase' on all names)
    def self.get_from_name(user_key, project_name)
      return nil if project_name.nil?
      projects = list(user_key)
      selected_projects = projects.select { |p| p.name.downcase == project_name.downcase }
      selected_projects.first rescue nil
    end
    
    # List all projects
    def self.list(user_key)
      ProjectsListApiCall.new(user_key).call
    end
    
    # load more infos (body) for the current project
    def load_info(user_key)
      ProjectInfoApiCall.new(user_key, self).call
    end
    
    # List all actions associated with the current project
    # - you can specify if you want to retrieve the already-done actions
    def get_actions(user_key, showdone = false)
      Nozbe::Action.list_for_project(user_key, id, showdone).collect { |action|
        action.project = self
        action
      }
    end
    
    # List all notes associated with the current project
    def get_notes(user_key)
      Nozbe::Note.list_for_project(user_key, id).collect { |note|
        note.project = self
        note
      }
    end
    
    # Save the current Project instance
    # - used to create a new project, not to save an already existing but modified project.
    # - return the instance, with its new ID set
    def save!(user_key)
      ProjectNewApiCall.new(user_key, self).call
    end
  end
  
  # This class is used internaly by the Project class 
  # to make the API call that list all projects
  class ProjectsListApiCall < Nozbe::ApiCall
    action :projects
    # Parse the JSON response, and return an Array of Project instances
    def parse(json)
      projects = super(json)
      projects.collect do |raw_project|
        project = Project.new
        project.id = raw_project["id"]
        project.name = raw_project["name"]
        project.count = raw_project["count"]
        project
      end
    end
  end
  
  # This class is used internaly by the Project class 
  # to make the API call that retrieve the infos of a project
  class ProjectInfoApiCall < Nozbe::ApiCall
    action :info
    def initialize(user_key, project)
      super(user_key, {:what => :project, :id => project.id})
      @project = project
    end
    # Parse the JSON response, and return the project instance with its infos set
    def parse(json)
      raw_project = super(json)
      @project.name = raw_project["name"]
      @project.body = raw_project["body"]
      @project.body_show = raw_project["body_show"]
      @project
    end
  end
  
  # This class is used internaly by the Project class 
  # to make the API call that create a new project
  class ProjectNewApiCall < Nozbe::ApiCall
    action :newproject
    def initialize(user_key, project)
      super(user_key, {
          :name => url_encode(project.name), 
          :body => url_encode(project.body)})
      @project = project
    end
    # Parse the JSON response, and return the project instance with its ID set
    def parse(json)
      res = super(json)
      @project.id = res["response"]
      @project
    end
  end
  
end