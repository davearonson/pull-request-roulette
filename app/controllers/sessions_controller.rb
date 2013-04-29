class SessionsController < ApplicationController
  def create
    session[:auth_code] = params[:code]
    final_url = params[:final_url]
    ah = auth_hash
    session[:login] = ah.extra.raw_info.login
    session[:name] = ah.info.name
    dest = params[:final_url]
    #@user = User.find_or_create_by_login_and_name(login, name)
    #self.current_user = @user
    redirect_to final_url
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
