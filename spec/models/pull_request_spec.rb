require 'spec_helper'

describe PullRequest do

  describe '.from_url' do

    it 'accepts open pulls' do
      expect(PullRequest.from_url(url: open_pr_url, submitter: 'whatever')).
          to be_valid
    end

  end

  describe '#open?' do

    # NOTE:  NO MOCKING GITHUB IN HERE!  THESE ARE INTEGRATION TESTS!
    # WARNING:  MAY EXCEED RATE LIMIT!  TODO: LOOK INTO DOING AUTH....
    describe 'looks at pull status' do

      it 'accepts open pulls' do
        test_pr_validations(open_pr_url, found: true, open: true, errors: false)
      end

      it 'rejects closed but unmerged pulls' do
        test_pr_validations(closed_pr_url, found: true, open: false, errors: true)
      end

      it 'rejects merged pulls' do
        test_pr_validations(merged_pr_url, found: true, open: false, errors: true)
      end

      it 'rejects nonexistent pulls' do
        test_pr_validations(open_pr_url.gsub('14', 'url: 999999999'),
                            found: false, open: false, errors: true)
      end

      it 'rejects pulls on nonextant repos' do
        test_pr_validations(open_pr_url.gsub('davearonson',
                                             'There-Better-Be-No-Such-User'),
                            found: false, open: false, errors: true)
      end

      it 'rejects pulls on things not even at Github' do
        test_pr_validations(open_pr_url.gsub('github', 'bughit'),
                            found: false, open: false, errors: true)
      end

    end

  end

  describe '.parse_url' do

    describe 'parses' do

      it 'canonical github URLs' do
        expect(PullRequest.parse_url(open_pr_url)).to eq open_pr_parts
      end

      it 'valid URLs w/ plain http, not httpS' do
        expect(PullRequest.parse_url(open_pr_url.gsub('https://', 'http://'))).
            to eq open_pr_parts
      end

      it 'valid URLs w/ www' do
        expect(PullRequest.parse_url(open_pr_url.gsub('https://',
                                                      'https://www.'))).
            to eq open_pr_parts
      end

      it 'valid URLs w/ www AND plain http' do
        expect(PullRequest.parse_url(open_pr_url.gsub('https://',
                                                      'http://www.'))).
            to eq open_pr_parts
      end

      it 'valid URLs w/o http or https' do
        expect(PullRequest.parse_url(open_pr_url.gsub('https://', ''))).
            to eq open_pr_parts
      end

      it 'valid URLs w/o http or https AND w/ www' do
        expect(PullRequest.parse_url(open_pr_url.gsub('https://', 'www.'))).
            to eq open_pr_parts
      end

    end

    describe 'rejects' do

      it 'URLs not at github' do
        expect(PullRequest.parse_url(open_pr_url.gsub('github', 'bughit'))).
           to be_nil
      end

      it 'URLs missing a piece' do
        expect(PullRequest.parse_url(open_pr_url.gsub('/pull/', '/'))).to be_nil
      end

      it 'URLs with extra junk tacked onto the end' do
        expect(PullRequest.parse_url(open_pr_url + '?foo=bar')).to be_nil
      end
    end

  end

end

private

def test_pr_validations(url, options)
  pr = PullRequest.from_url(url: url, submitter: 'some-handle')
  expect(pr.found?).to eq options[:found]
  expect(pr.open?).to eq options[:open]
  expect(pr.errors[:base].empty?).not_to eq options[:errors]
end
