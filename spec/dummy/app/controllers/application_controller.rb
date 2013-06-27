class ApplicationController < ActionController::Base
  protect_from_forgery

  layout 'application'

  def index; end
  def no_slash; end
  def trailing_slash; end
end
