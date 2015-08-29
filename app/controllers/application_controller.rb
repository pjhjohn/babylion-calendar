class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  def encrypt(message)
    require 'digest'
    sha256 = Digest::SHA256.new
    digest = sha256.base64digest message
    return digest
  end
  
  def admin_required
    if user_active?
      if User.find_by_id(session[:user_id]).is_admin
        return true
      else
        flash[:message_navbar] = "Admin is required"
        flash[:success_navbar] = false
        redirect_to "/"
      end
    else
      signin_required
    end
  end
  
  def signin_required
    unless user_active?
      flash[:message_navbar] = "Sign-in is required"
      flash[:success_navbar] = false
      redirect_to "/" # flashing message that sign-in is required
    end
  end
  
  def signout_required
    if user_active?
      flash[:message_navbar] = "Sign-out is required"
      flash[:success_navbar] = false
      redirect_to "/" # flashing message that sign-in is required
    end
  end
  
  def user_active?
    return true unless session[:user_id].nil? or User.find_by_id(session[:user_id]).nil?
    false
  end
  
  def set_navbar_category(category = "")
    session[:navbar_category] = category
  end
end
