module Nozbe
  class User
    attr_accessor :email, :password, :key

    def initialize(email, password)
      @email = email
      @password = password
      @key = nil
    end
    
    def login()
      @key = LoginApiCall.new(self).call
    end
    
    def logged_in?()
      not @key.nil?
    end
  end
  
  class LoginApiCall < Nozbe::ApiCall
    action :login
    def initialize(user)
      super(nil, {:email => user.email, :password => user.password})
    end
    def parse(json)
      res = super(json)
      res["key"]
    end
  end
  
end