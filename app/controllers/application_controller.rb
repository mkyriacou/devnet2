class ApplicationController < ActionController::Base
  #If you only want to block certain parts of the site you can add this to individual controllers.
  before_filter :authenticate_user!

  protect_from_forgery
end
