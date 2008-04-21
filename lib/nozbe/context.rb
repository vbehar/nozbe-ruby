module Nozbe
  # Context class
  # - In Nozbe, a context is used to group Action (or Note) together
  # - Some pre-defined contexts are already set
  # - The number of user-specific contexts is limited by the Nozbe-account
  class Context
    DEFAULT_CONTEXT_NAME = "No context"

    attr_accessor :id, :name, :icon, :body, :body_show, :count
    
    # return the default Context instance : 
    # the context with its name set to DEFAULT_CONTEXT_NAME
    def self.get_default_context(user_key)
      get_from_name(user_key, DEFAULT_CONTEXT_NAME)
    end
    
    # return a Context instance from the given context_name
    # - it may return nil if there is no matches
    # <b>WARNING</b> :
    # the Nozbe-API doesn't provide such a method, 
    # so we load all contexts and compare the names with the given name
    # - the comparison is case-insensitive (use 'downcase' on all names)
    def self.get_from_name(user_key, context_name)
      return nil if context_name.nil?
      contexts = list(user_key)
      selected_contexts = contexts.select { |c| c.name.downcase == context_name.downcase }
      selected_contexts.first rescue nil
    end
    
    # List all contexts
    def self.list(user_key)
      ContextsListApiCall.new(user_key).call
    end
    
    # load more infos (body) for the current context
    def load_info(user_key)
      ContextInfoApiCall.new(user_key, self).call
    end
    
    # List all actions associated with the current context
    # - you can specify if you want to retrieve the already-done actions
    def get_actions(user_key, showdone = false)
      Nozbe::Action.list_for_context(user_key, id, showdone).collect { |action|
        action.context = self
        action
      }
    end
    
    # List all notes associated with the current context
    def get_notes(user_key)
      Nozbe::Note.list_for_context(user_key, id).collect { |note|
        note.context = self
        note
      }
    end
  end
  
  # This class is used internaly by the Context class 
  # to make the API call that list all contexts
  class ContextsListApiCall < Nozbe::ApiCall
    action :contexts
    # Parse the JSON response, and return an Array of Context instances
    def parse(json)
      contexts = super(json)
      contexts.collect do |raw_context|
        context = Context.new
        context.id = raw_context["id"]
        context.name = raw_context["name"]
        context.count = raw_context["count"]
        context.count = raw_context["icon"]
        context
      end
    end
  end
  
  # This class is used internaly by the Context class 
  # to make the API call that retrieve the infos of a context
  class ContextInfoApiCall < Nozbe::ApiCall
    action :info
    def initialize(user_key, context)
      super(user_key, {:what => :context, :id => context.id})
      @context = context
    end
    # Parse the JSON response, and return the context instance with its infos set
    def parse(json)
      raw_context = super(json)
      @context.name = raw_context["name"]
      @context.body = raw_context["body"]
      @context.body_show = raw_context["body_show"]
      @context.icon = raw_context["icon"]
      @context
    end
  end
  
end