class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authorize_github_and_return_to final_url
    github = Github.new(client_id: ENV['GITHUB_KEY'],
                        client_secret: ENV['GITHUB_SECRET'])
    redirect_uri = oauth_callback_url(:github, final_url: final_url)
    auth_address = github.authorize_url(redirect_uri: redirect_uri)
    redirect_to auth_address
  end

  def signed_in?
    session[:auth_code].present?
  end

end
