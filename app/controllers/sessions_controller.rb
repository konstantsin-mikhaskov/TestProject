class SessionsController < ApplicationController
  def new
    @emails = Email.paginate(page: params[:page], per_page: 50)
  end

  def create
    user = User.from_omniauth(env["omniauth.auth"])
    #user.refresh_token_if_expired    It's method for refresh user token
    #GetEmails.perform_async(user.id)  It's method for async get email
    user.get_emails  #It's method for sync emails
    @emails = Email.where(user_id: user.id).paginate(page: params[:page], per_page: 50)
    session[:user_id] = user.id
    redirect_to root_url, notice: "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end

  def failure
    redirect_to root_url, alert: "Authentication failed, please try again."
  end
end
