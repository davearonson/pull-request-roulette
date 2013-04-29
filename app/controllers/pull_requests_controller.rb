class PullRequestsController < ApplicationController
  before_action :set_pull_request, only: [:show, :edit, :update, :destroy]

  # TODO: extract authorization stuff to a before_action on new and destroy

  # GET /pull_requests
  # GET /pull_requests.json
  def index
    @pull_requests = PullRequest.all
  end

  # GET /pull_requests/1
  # GET /pull_requests/1.json
  def show
  end

  # GET /pull_requests/new
  def new
    code = session[:auth_code]
    if code.present?
      @pull_request = PullRequest.new
    else
      authorize_github_and_return_to new_pull_request_path
    end
  end

  # GET /pull_requests/1/edit
  def edit
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

  # PATCH/PUT /pull_requests/1
  # PATCH/PUT /pull_requests/1.json
  def update
    respond_to do |format|
      if @pull_request.update(pull_request_params)
        format.html { redirect_to pull_requests_path, notice: 'Pull request was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @pull_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pull_requests/1
  # DELETE /pull_requests/1.json
  def destroy
    code = session[:auth_code]
    if code.present?
      @pull_request.destroy
      respond_to do |format|
        format.html { redirect_to pull_requests_url }
        format.json { head :no_content }
      end
    else
      authorize_github_and_return_to pull_requests_path
    end
  end

  private

  def authorize_github_and_return_to final_url
    github = Github.new(client_id: ENV['GITHUB_KEY'],
                        client_secret: ENV['GITHUB_SECRET'])
    redirect_uri = oauth_callback_url(:github, final_url: final_url)
    auth_address = github.authorize_url(redirect_uri: redirect_uri)
    redirect_to auth_address
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_pull_request
    @pull_request = PullRequest.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def pull_request_params
    params[:pull_request].permit(:url)
  end

end
