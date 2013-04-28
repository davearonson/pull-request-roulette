require 'spec_helper'

describe PullRequest do

  describe '#open?' do

    # NOTE:  NO MOCKING GITHUB IN HERE!  THESE ARE INTEGRATION TESTS!
    describe 'looks at pull status' do

      it 'accepts open pulls' do
        PullRequest.new(url: good_url).open?.should be_true
      end

      it 'rejects closed pulls' do
        PullRequest.new(url: good_url.gsub('14', 'url: 10262')).
          open?.should be_false
      end

      it 'rejects nonexistent pulls' do
        PullRequest.new(url: good_url.gsub('14', 'url: 999999999')).
          open?.should be_false
      end

      it 'rejects pulls on nonextant repos' do
        PullRequest.new(url: good_url.gsub('davearonson',
                                           'There-Better-Be-No-Such-User')).
          open?.should be_false
      end

    end

  end

  describe ".parse_url" do

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

    describe 'rejects' do

      it 'URLs not at github' do
        PullRequest.parse_url(good_url.gsub('github', 'bughit')).should be_nil
      end

      it 'URLs missing a piece' do
        PullRequest.parse_url(good_url.gsub('/pull/', '/')).should be_nil
      end

      it 'URLs with extra junk tacked onto the end' do
        PullRequest.parse_url(good_url + '?foo=bar').should be_nil
      end
    end


  end

end
