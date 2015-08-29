class AuthController < ApplicationController
  before_filter :signin_required, only: [:signout]
  before_filter :signout_required, only: [:index, :signin, :signup]
  def index
  end
  
  def signup
    duplicate_user = User.where(username: params[:username]).take
    if duplicate_user.nil?
      new_user = User.new
      new_user.username = params[:username]
      new_user.password = encrypt(params[:password])
      new_user.save
      flash[:message_navbar] = "가입하였습니다"
      flash[:success_navbar] = true
    else 
      flash[:message_navbar] = "가입에 실패하였습니다"
      flash[:success_navbar] = false
    end
    redirect_to "/"
  end
  
  def signin
    user = User.where(
      username: params[:username],
      password: encrypt(params[:password])
    ).take
    unless user.nil?
      session[:user_id] = user.id
      flash[:message_navbar] = "로그인 되었습니다"
      flash[:success_navbar] = true
    else
      flash[:message_navbar] = "로그인에 실패하였습니다"
      flash[:success_navbar] = false
    end
    redirect_to "/", alert: "Watch it, mister!"
  end
  
  def signout
    reset_session
    redirect_to "/"
  end
end
