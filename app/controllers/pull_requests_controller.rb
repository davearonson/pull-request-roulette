class PullRequestsController < ApplicationController
  before_action :set_pull_request, only: [:show, :edit, :update, :destroy]

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
    @pull_request = PullRequest.new
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
    @pull_request.destroy
    respond_to do |format|
      format.html { redirect_to pull_requests_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pull_request
      @pull_request = PullRequest.find(params[:id])
    end
end
