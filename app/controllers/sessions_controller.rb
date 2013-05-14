class SessionsController < ApplicationController

  def new
    authorize_github_and_return_to root_path
  end

  def create
    session[:auth_code] = params[:code]
    ah = auth_hash
    session[:handle] = ah.info.nickname
    session[:name] = ah.info.name
    #@user = User.find_or_create_by_login_and_name(login, name)
    #self.current_user = @user
    redirect_to params[:final_url]
  end

  def destroy
    session[:auth_code] = nil
    redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

end
