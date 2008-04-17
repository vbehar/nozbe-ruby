module Nozbe
  class Project
    DEFAULT_PROJECT_NAME = "inbox"
    
    attr_accessor :id, :name, :body, :body_show, :count
    
    def self.get_default_project(user_key)
      projects = list(user_key)
      selected_projects = projects.select { |p| p.name.downcase == DEFAULT_PROJECT_NAME }
      selected_projects.first if selected_projects and !selected_projects.empty?
      projects.first
    end
    
    def self.list(user_key)
      ProjectsListApiCall.new(user_key).call
    end
    
    def load_info(user_key)
      ProjectInfoApiCall.new(user_key, self).call
    end
    
    def get_actions(user_key, showdone = false)
      Nozbe::Action.list_for_project(user_key, id, showdone).collect { |action|
        action.project = self
        action
      }
    end
    
    def get_notes(user_key)
      Nozbe::Note.list_for_project(user_key, id).collect { |note|
        note.project = self
        note
      }
    end
    
    def save!(user_key)
      ProjectNewApiCall.new(user_key, self).call
    end
  end
  
  class ProjectsListApiCall < Nozbe::ApiCall
    action :projects
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
  
  class ProjectInfoApiCall < Nozbe::ApiCall
    action :info
    def initialize(user_key, project)
      super(user_key, {:what => :project, :id => project.id})
      @project = project
    end
    def parse(json)
      raw_project = super(json)
      @project.name = raw_project["name"]
      @project.body = raw_project["body"]
      @project.body_show = raw_project["body_show"]
      @project
    end
  end
  
  class ProjectNewApiCall < Nozbe::ApiCall
    action :newproject
    def initialize(user_key, project)
      super(user_key, {
          :name => url_encode(project.name), 
          :body => url_encode(project.body)})
      @project = project
    end
    def parse(json)
      res = super(json)
      @project.id = res["response"]
      @project
    end
  end
  
end