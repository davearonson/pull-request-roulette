require 'rails_helper.rb'

describe 'close a review' do

  before do
    Given an_existing_pr reviewer: "some-reviewer"
    Given I am_signed_in "some-reviewer"
  end

  it 'lets a logged-in reviewer close his reviews' do
    When I list_the_prs
    Then I see_it_with_reviewer "some-reviewer"
    When I close_its_review
    Then I see_it_with_reviewer "None"
    # TODO LATER MAYBE: keep some review history?
  end

  it "doesn't have the button for unauthorized people"

  private

  def close_its_review
    within("#pr-#{@pr.id}") { click_on "Close Review" }
  end

end
