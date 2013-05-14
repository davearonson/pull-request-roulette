class PullRequestsController < ApplicationController
  before_action :authorize, only: [:new, :destroy]
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
    respond_to do |format|
      if @pull_request.save
        format.html { redirect_to pull_requests_path, notice: 'Pull request was successfully created.' }
        format.json { render action: 'show', status: :created, location: @pull_request }
      else
        format.html { render action: 'new' }
        format.json { render json: @pull_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if signed_in?
        @pull_request = PullRequest.find(params[:id])
        @pull_request.destroy
        format.html { redirect_to pull_requests_url }
        format.json { head :no_content }
      else
        format.html { redirect_to pull_requests_url, notice: 'You must be logged in to Take a PR!' }
        format.json { render json: @pull_request.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def authorize
    authorize_github_and_return_to [request.protocol,
                                    request.host_with_port,
                                    request.fullpath,
                                    '?',
                                    request.params.to_param].join unless signed_in?
  end

end
