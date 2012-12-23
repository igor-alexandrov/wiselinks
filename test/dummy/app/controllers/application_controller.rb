class ApplicationController < ActionController::Base
  protect_from_forgery  
  
  def index
    render :pdf => 'filename'
  end  
end
