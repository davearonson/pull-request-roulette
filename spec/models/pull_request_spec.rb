require 'spec_helper'

describe PullRequest do

  describe '#is_an_open_github_pr?' do

    describe 'looks at url format' do

      describe 'accepts' do

        before :each do
          Github::PullRequests.any_instance.should_receive(:find).
            and_return(OpenStruct.new(state: 'open'))
        end

        it 'canonical github URLs' do
          PullRequest.new(url: good_url).
            is_an_open_github_pr?.should be_true
        end

        it 'valid URLs w/o httpS' do
          PullRequest.new(url: good_url.gsub('https://', 'http://')).
            is_an_open_github_pr?.should be_true
        end

        it 'valid URLs w/ www' do
          PullRequest.new(url: good_url.gsub('https://', 'https://www.')).
            is_an_open_github_pr?.should be_true
        end

        it 'valid URLs w/ www AND plain http' do
          PullRequest.new(url: good_url.gsub('https://', 'http://www.')).
            is_an_open_github_pr?.should be_true
        end

      end

      describe 'rejects' do

        it 'URLs not at github' do
          PullRequest.new(url: good_url.gsub('github', 'bughit')).
            is_an_open_github_pr?.should be_false
        end

        it 'URLs missing a piece' do
          PullRequest.new(url: good_url.gsub('/pull/', '/')).
            is_an_open_github_pr?.should be_false
        end

        it 'URLs with extra junk tacked onto the end' do
          PullRequest.new(url: good_url + '?foo=bar').
            is_an_open_github_pr?.should be_false
        end
      end

    end

    # NOTE:  NO MOCKING GITHUB IN HERE!  THESE ARE INTEGRATION TESTS!
    describe 'looks at pull status' do

      it 'accepts open pulls' do
        PullRequest.new(url: good_url).
          is_an_open_github_pr?.should be_true
      end

      it 'rejects closed pulls' do
        PullRequest.new(url: good_url.gsub('2045', 'url: 10262')).
          is_an_open_github_pr?.should be_false
      end

      it 'rejects nonexistent pulls' do
        PullRequest.new(url: good_url.gsub('2045', 'url: 999999999')).
          is_an_open_github_pr?.should be_false
      end

      it 'rejects pulls on nonextant repos' do
        PullRequest.new(url: good_url.gsub('rails/rails', 'nosuch/nosuch')).
          is_an_open_github_pr?.should be_false
      end

    end

  end

  describe "parse_url" do

    describe 'parses' do

      it 'canonical github URLs' do
        PullRequest.parse_url(good_url).should == good_parts
      end

      it 'valid URLs w/o httpS' do
        PullRequest.parse_url(good_url.gsub('https://', 'http://')).
          should == good_parts
      end

      it 'valid URLs w/ www' do
        PullRequest.parse_url(good_url.gsub('https://', 'https://www.')).
          should == good_parts
      end

      it 'valid URLs w/ www AND plain http' do
        PullRequest.parse_url(good_url.gsub('https://', 'http://www.')).
          should == good_parts
      end

    end

  end

end

private

# HELPERS

def good_parts
  ['rails', 'rails', '2045']
end

def good_url
  'http://github.com/%s/%s/pull/%d' % good_parts
end

