class PullRequestsController < ApplicationController
  before_action :authorize, except: :index
  helper_method :signed_in?

  def index
    @pull_requests = PullRequest.all
  end

  def new
    @pull_request = PullRequest.new
  end

  def create
    @pull_request = PullRequest.from_url(url: params[:url],
                                         submitter: current_user_handle)
    if @pull_request.save
      redirect_to(pull_requests_path,
                  flash: { success: 'Pull request was successfully created.' })
    else
      render 'new'
    end
  end

  def take
    @pull_request = PullRequest.find(params[:pull_request_id])
    if @pull_request.reviewer.present?
      # someone's trying to pull a fast one
      redirect_to(pull_requests_path,
                  flash: { alert: 'Sorry, that PR is already under review.' })
    else
      @pull_request.update_attributes!(reviewer: current_user_handle)
      redirect_to pull_requests_url
    end
  end

  def close_review
    @pull_request = PullRequest.find(params[:pull_request_id])
    if @pull_request.reviewer != current_user_handle
      # someone's trying to pull a fast one
      redirect_to(pull_requests_path,
                  flash: { alert: 'Sorry, you are not authorized to close that review.  Only the coder, reviewer, submitter, or project owner can do that.' })
    else
      @pull_request.update_attributes!(reviewer: nil)
      redirect_to pull_requests_url
    end
  end

  private

  def authorize
    authorize_github_and_return_to(request.url) unless signed_in?
  end

end
