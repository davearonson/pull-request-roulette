require 'spec_helper'

describe PullRequest do

  describe '.from_url' do

    it 'accepts open pulls' do
        PullRequest.from_url(open_pr_url).should be_valid
    end

  end

  describe '#validate_open' do

    # NOTE:  NO MOCKING GITHUB IN HERE!  THESE ARE INTEGRATION TESTS!
    describe 'looks at pull status' do

      it 'accepts open pulls' do
        test_pr_validations(open_pr_url, true, true, false)
      end

      it 'rejects closed but unmerged pulls' do
        test_pr_validations(closed_pr_url, true, false, true)
      end

      it 'rejects merged pulls' do
        test_pr_validations(merged_pr_url, true, false, true)
      end

      it 'rejects nonexistent pulls' do
        test_pr_validations(open_pr_url.gsub('14', 'url: 999999999'),
                            false, false, true)
      end

      it 'rejects pulls on nonextant repos' do
        test_pr_validations(open_pr_url.gsub('davearonson',
                                             'There-Better-Be-No-Such-User'),
                            false, false, true)
      end

      it 'rejects pulls on things not even at Github' do
        test_pr_validations(open_pr_url.gsub('github','bughit'),
                            false, false, true)
      end

    end

  end

  describe ".parse_url" do

    describe 'parses' do

      it 'canonical github URLs' do
        PullRequest.parse_url(open_pr_url).should == open_pr_parts
      end

      it 'valid URLs w/o httpS' do
        PullRequest.parse_url(open_pr_url.gsub('https://', 'http://')).
          should == open_pr_parts
      end

      it 'valid URLs w/ www' do
        PullRequest.parse_url(open_pr_url.gsub('https://', 'https://www.')).
          should == open_pr_parts
      end

      it 'valid URLs w/ www AND plain http' do
        PullRequest.parse_url(open_pr_url.gsub('https://', 'http://www.')).
          should == open_pr_parts
      end

    end

    describe 'rejects' do

      it 'URLs not at github' do
        PullRequest.parse_url(open_pr_url.gsub('github', 'bughit')).should be_nil
      end

      it 'URLs missing a piece' do
        PullRequest.parse_url(open_pr_url.gsub('/pull/', '/')).should be_nil
      end

      it 'URLs with extra junk tacked onto the end' do
        PullRequest.parse_url(open_pr_url + '?foo=bar').should be_nil
      end
    end


  end

end

private

def test_pr_validations(url, found, open, errors)
  pr = PullRequest.from_url(url)
  pr.validate_found.should == found
  pr.validate_open.should == open
  pr.errors[:base].empty?.should_not == errors
end
