class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_cookies

  def set_cookies
    session[:user] ||= cookies[:user] || rand.to_s[2..-1]
    @current_user = session[:user]
    cookies[:user] = {:value => session[:user], :expires => Time.now + 60*60*24*7}
  end
end
