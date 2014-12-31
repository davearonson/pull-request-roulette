class SessionsController < ApplicationController

  def new
    referer = request.referer
    authorize_github_and_return_to referer.present? ? referer : root_path
  end

  def create
    session[:auth_code] = params[:code]
    ah = auth_hash
    session[:handle] = ah.info.nickname
    session[:name] = ah.info.name
    redirect_to session[:redirect_url] || root_path
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
