class AddSubmitterToPullRequest < ActiveRecord::Migration
  def change
    add_column :pull_requests, :submitter, :string, null: false, default: 'UNKNOWN'
  end
end
