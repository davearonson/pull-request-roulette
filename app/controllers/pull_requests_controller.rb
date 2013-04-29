class PullRequestsController < ApplicationController
  helper_method :signed_in?

  # TODO: extract authorization stuff to a before_action on new and destroy

  # GET /pull_requests
  # GET /pull_requests.json
  def index
    @pull_requests = PullRequest.all
  end

  # GET /pull_requests/new
  def new
    if signed_in?
      @pull_request = PullRequest.new
    else
      authorize_github_and_return_to new_pull_request_path
    end
  end

  # POST /pull_requests
  # POST /pull_requests.json
  def create
    @pull_request = PullRequest.from_url(params[:url])

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

  # DELETE /pull_requests/1
  # DELETE /pull_requests/1.json
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

end
