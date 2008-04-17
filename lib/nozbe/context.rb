module Nozbe
  class Context
    DEFAULT_CONTEXT_NAME = "No context"

    attr_accessor :id, :name, :icon, :body, :body_show, :count
    
    def self.get_default_context(user_key)
      get_from_name(user_key, DEFAULT_CONTEXT_NAME)
    end
    
    def self.get_from_name(user_key, context_name)
      contexts = list(user_key)
      context_name = '' if context_name.nil?
      selected_contexts = contexts.select { |c| c.name.downcase == context_name.downcase }
      if selected_contexts and !selected_contexts.empty?
        selected_contexts.first
      else
        contexts.first
      end
    end
    
    def self.list(user_key)
      ContextsListApiCall.new(user_key).call
    end
    
    def load_info(user_key)
      ContextInfoApiCall.new(user_key, self).call
    end
    
    def get_actions(user_key, showdone = false)
      Nozbe::Action.list_for_context(user_key, id, showdone).collect { |action|
        action.context = self
        action
      }
    end
    
    def get_notes(user_key)
      Nozbe::Note.list_for_context(user_key, id).collect { |note|
        note.context = self
        note
      }
    end
  end
  
  class ContextsListApiCall < Nozbe::ApiCall
    action :contexts
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
  
  class ContextInfoApiCall < Nozbe::ApiCall
    action :info
    def initialize(user_key, context)
      super(user_key, {:what => :context, :id => context.id})
      @context = context
    end
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