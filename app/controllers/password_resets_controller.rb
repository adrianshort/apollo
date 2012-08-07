class PasswordResetsController < ApplicationController
#   before_filter :require_no_user
    
  def create
    @user = User.find_by_email(params[:email])

    if @user
      unless @user.deliver_reset_password_instructions!
        redirect_to(root_path, :notice => "Please wait a while before requesting another password reset.")
        return
      end
    end
    redirect_to(new_password_reset_path, :notice => "Instructions have been sent to your email.")
  end

  def edit
    @user = User.load_from_reset_password_token(params[:id])
    @token = params[:id]
    not_authenticated unless @user
  end

  def update
    @token = params[:token]
    @user = User.load_from_reset_password_token(params[:token])
    not_authenticated unless @user
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password!(params[:user][:password])
      redirect_to(root_path, :notice => "Password changed OK")
    else
      render :action => "edit"
    end
  end
end
