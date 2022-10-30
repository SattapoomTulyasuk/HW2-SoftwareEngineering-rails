class ApplicationController < ActionController::Base
  protect_from_forgery

  include ApplicationHelper

  def welcome
    if !logged_in?
      redirect_to login_path
    end
  end

end
