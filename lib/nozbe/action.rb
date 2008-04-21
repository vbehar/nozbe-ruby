module Nozbe
  # Action class
  # - In Nozbe, an action is a todo task.
  # - It can be 'done' or not, or be your 'next' action or not.
  # - It is associated with a Project and a Context
  class Action
    attr_accessor :id, :name, :name_show, :done, :done_time, :time, :next, :project, :context
    
    # List all actions
    # - you can specify if you want to retrieve the already-done actions
    # <b>WARNING !</b>
    # The Nozbe-API doesn't provide such a method, so we use multiple API calls :
    # - load all projects
    # - then, for each project, load all actions
    def self.list(user_key, showdone = false)
      Nozbe::Project.list(user_key).inject([]) { |all_actions, project|
        all_actions + project.get_actions(user_key, showdone)
      }
    end
    
    # List all 'next' actions
    def self.list_next(user_key)
      ActionsListApiCall.new(user_key, {:what => :next}).call
    end
    
    # List all actions for the given Project (using its ID)
    # - you can specify if you want to retrieve the already-done actions
    def self.list_for_project(user_key, project_id, showdone = false)
      params = {:what => :project, :id => project_id}
      params[:showdone] = "1" if showdone
      ActionsListApiCall.new(user_key, params).call
    end
    
    # List all actions for the given Context (using its ID)
    # - you can specify if you want to retrieve the already-done actions
    def self.list_for_context(user_key, context_id, showdone = false)
      params = {:what => :context, :id => context_id}
      params[:showdone] = "1" if showdone
      ActionsListApiCall.new(user_key, params).call
    end
    
    # Mark all given Action instances as 'done'
    # - return true or false
    def self.done!(user_key, actions = [])
      return false if actions.empty?
      ActionCheckApiCall.new(user_key, actions.collect{|action|action.id}).call
    end
    
    # Mark the current Action instance as 'done'
    # - return true or false
    def done!(user_key)
      self.class.done!(user_key, [self])
    end
    
    # Save the current Action instance
    # - used to create a new action, not to save an already existing but modified action.
    # - return the instance, with its new ID set
    def save!(user_key)
      ActionNewApiCall.new(user_key, self).call
    end
  end
  
  # This class is used internaly by the Action class 
  # to make the API call that list all actions
  class ActionsListApiCall < Nozbe::ApiCall
    action :actions
    # Parse the JSON response, and return an Array of Action instances, 
    # or an empty array if no actions are found.
    def parse(json)
      actions = super(json)
      return [] if actions.nil?
      actions.collect do |raw_action|
        action = Action.new
        action.id = raw_action["id"]
        action.name = raw_action["name"]
        action.name_show = raw_action["name_show"]
        action.done = raw_action["done"] == 1
        action.done_time = raw_action["done_time"]
        action.time = raw_action["time"]
        action.next = raw_action["next"] == "next"
        action.project = Nozbe::Project.new
        action.project.id = raw_action["project_id"]
        action.project.name = raw_action["project_name"]
        action.context = Nozbe::Context.new
        action.context.id = raw_action["context_id"]
        action.context.name = raw_action["context_name"]
        action.context.icon = raw_action["context_icon"]
        action
      end
    end
  end
  
  # This class is used internaly by the Action class 
  # to make the API call that mark some actions as 'done'
  class ActionCheckApiCall < Nozbe::ApiCall
    action :check
    def initialize(user_key, actions_ids = [])
      super(user_key, {:ids => actions_ids})
    end
    # Parse the JSON response, and return true or false
    def parse(json)
      res = super(json)
      res["response"] == "ok"
    end
  end
  
  # This class is used internaly by the Action class 
  # to make the API call that create a new action
  class ActionNewApiCall < Nozbe::ApiCall
    action :newaction
    def initialize(user_key, action)
      params = {
        :name => url_encode(action.name), 
        :project_id => action.project.id, 
        :context_id => action.context.id,
        :time => action.time}
      params[:next] = "true" if action.next
      super(user_key, params)
      @action = action
    end
    # Parse the JSON response, and return the action instance with its ID set
    def parse(json)
      res = super(json)
      @action.id = res["response"]
      @action
    end
  end
  
end
