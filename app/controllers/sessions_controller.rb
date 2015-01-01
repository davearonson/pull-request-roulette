class SessionsController < ApplicationController

  def new
    referer = request.referer
    authorize_github_and_return_to referer.present? ? referer : root_path
  end

  def create
    session[:auth_code] = params[:code]
    ah_info = auth_hash.info
    session[:handle] = ah_info.nickname
    session[:name] = ah_info.name
    url = session.delete :redirect_url
    redirect_to url.present? ? url : root_path
  end

  def destroy
    [:auth_code, :handle, :name].each { |sym| session.delete sym }
    redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

end
