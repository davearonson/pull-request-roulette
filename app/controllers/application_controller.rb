class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ApplicationHelper

  def authorize_github_and_return_to(final_url)
    github = Github.new(client_id: ENV['GITHUB_KEY'],
                        client_secret: ENV['GITHUB_SECRET'])
    session[:redirect_url] = final_url
    redirect_to github.authorize_url
  end

end
