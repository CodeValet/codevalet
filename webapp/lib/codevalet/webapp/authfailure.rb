require 'sinatra/base'

module CodeValet
  module WebApp
    # Simple Sinatra application for enumerating a complete authentication
    # failure with Warden
    class AuthFailre < Sinatra::Base
      get '/unauthenticated' do
        status 403
        <<-EOS
        <h2>Unable to authenticate, sorry bud.</h2>
        <p>#{env['warden'].message}</p>
        <p>#{ENV['REDIRECT_URI']}</p>
        <p>#{ENV['GITHUB_CLIENT_ID']}</p>
        EOS
      end
    end
  end
end
