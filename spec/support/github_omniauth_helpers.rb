OmniAuth.config.test_mode = true

omniauth_hash = { 'provider' => 'github',
                  'uid' => '12345',
                  'info' => { 'name' => 'Joe Shmoe',
                              'email' => 'joe@shmoe.com',
                              'nickname' => 'joeshmoe' } }

OmniAuth.config.add_mock(:github, omniauth_hash)
