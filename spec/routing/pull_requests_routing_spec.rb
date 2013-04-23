require "spec_helper"

describe PullRequestsController do
  describe "routing" do

    it "routes to #index" do
      get("/pull_requests").should route_to("pull_requests#index")
    end

    it "routes to #new" do
      get("/pull_requests/new").should route_to("pull_requests#new")
    end

    it "routes to #show" do
      get("/pull_requests/1").should route_to("pull_requests#show", :id => "1")
    end

    it "routes to #edit" do
      get("/pull_requests/1/edit").should route_to("pull_requests#edit", :id => "1")
    end

    it "routes to #create" do
      post("/pull_requests").should route_to("pull_requests#create")
    end

    it "routes to #update" do
      put("/pull_requests/1").should route_to("pull_requests#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/pull_requests/1").should route_to("pull_requests#destroy", :id => "1")
    end

  end
end
