class HomesController < ApplicationController

   def index
    if user_signed_in?
      redirect_to :controller => 'dashboards', :action => 'index'
    end
  end


end
