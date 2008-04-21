%w(api_call user project context action note).each do |f|
  require File.dirname(__FILE__) + "/nozbe/#{f}"
end

# Nozbe module, that provides a wrapper around the Nozber-API
module Nozbe
  
end

