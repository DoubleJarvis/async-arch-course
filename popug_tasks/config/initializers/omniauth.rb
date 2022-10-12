module OmniAuth
  module Strategies
    # tell OmniAuth to load our strategy
    # binding.pry
    autoload :PopugAuth, Rails.root.join('lib/strategies/popug_auth.rb').to_s
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :developer unless Rails.env.production?
  # provider :popug_auth, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :popug_auth, 
    'vDp3AawnbO2cFC6rXGayxymqwNQogM81L9Jl0ebZLYw', 
    'UKB2xDiXjAHTggs5uG6-F8rpdHgk-UP9UA37hk9dWmM',
    scope: 'all'
end

