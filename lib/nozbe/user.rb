module Nozbe
  # User class
  # - Represents a Nozbe-User
  # - Used to login (= get a user_key from the email and the password)
  class User
    attr_accessor :email, :password, :key

    # Default constructor, that used the user email and password
    def initialize(email, password)
      @email = email
      @password = password
      @key = nil
    end
    
    # Log into Nozbe :
    # - retrieve the user_key from the email and password, and return it
    def login()
      @key = LoginApiCall.new(self).call
    end
    
    # Is the user currently logged_in ?
    # - return true if the user_key is set (= not nil)
    def logged_in?()
      not @key.nil?
    end
  end
  
  # This class is used internaly by the User class 
  # to make the API call that login the user
  class LoginApiCall < Nozbe::ApiCall
    action :login
    def initialize(user)
      super(nil, {:email => user.email, :password => user.password})
    end
    # Parse the JSON response, and return the user_key (may be nil)
    def parse(json)
      res = super(json)
      res["key"]
    end
  end
  
end