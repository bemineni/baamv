class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user_is


  def current_user_is(other_user)
    current_user == other_user
  end

  def check_login_and_return_to_url(url)
    unless logged_in?
       redirect_to login_path(return_path: url), :notice => "First login to access this page."  
    end
  end
  
  def check_login
    not_authenticated unless logged_in?
  end
  
  def not_authenticated
    redirect_to login_url, :alert => "First login to access this page."
  end
  
end
