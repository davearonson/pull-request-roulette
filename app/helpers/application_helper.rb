module ApplicationHelper

  def current_user_handle
    session[:handle]
  end

  def current_user_name
    session[:name]
  end

  def github_user_url handle
    "https://github.com/#{handle}"
  end

  def signed_in?
    session[:auth_code].present?
  end

end
