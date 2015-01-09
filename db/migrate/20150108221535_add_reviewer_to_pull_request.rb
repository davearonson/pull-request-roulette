class AddReviewerToPullRequest < ActiveRecord::Migration
  def change
    add_column :pull_requests, :reviewer, :string, null: true
  end
end
