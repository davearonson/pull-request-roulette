OmniAuth.config.test_mode = true

omniauth_hash = { 'provider' => 'github',
                  'uid' => '12345',
                  'info' => { 'name' => 'Joe Shmoe',
                              'email' => 'joe@shmoe.com',
                              'nickname' => 'joeshmoe' } }

OmniAuth.config.add_mock(:github, omniauth_hash)

def set_up_faked_github_oauth
  ENV['GITHUB_KEY'] = @key = "this is the github key"
  ENV['GITHUB_SECRET'] = @secret = "this is the github secret"
  @github_auth_url = "github auth url"
  fake_github_client = OpenStruct.new(:authorize_url => @github_auth_url)
  expect(Github).to receive(:new).
                 with({ client_id: @key, client_secret: @secret }).
                 and_return(fake_github_client)
end
