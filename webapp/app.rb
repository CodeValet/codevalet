#!/usr/bin/env ruby

require 'sinatra/base'
require 'warden/github'
require 'yaml'

module CodeValet
  class AuthFailre < Sinatra::Base
    get '/unauthenticated' do
      status 403
      <<-EOS
      <h2>Unable to authenticate, sorry bud.</h2>
      <p>#{env['warden'].message}</p>
      EOS
    end
  end

  class App < Sinatra::Base
    include Warden::GitHub::SSO

    enable  :sessions
    enable  :raise_errors
    disable :show_exceptions

    set :public_folder, File.dirname(__FILE__) + '/assets'

    use Warden::Manager do |config|
      config.failure_app = AuthFailre
      config.default_strategies :github
      config.scope_defaults :default, :config => {
        :scope            => 'read:public_repo,user:email',
        :client_id        => ENV['GITHUB_CLIENT_ID'] || 'a6f2001b9e6c3fabf85c',
        :client_secret    => (ENV['GITHUB_CLIENT_SECRET'] || '0672e14addb9f41dec11b5da1219017edfc82a58').chomp,
        :redirect_uri     => ENV['REDIRECT_URI'] || 'http://localhost:9292/github/authenticate',
      }

      config.serialize_from_session { |key| Warden::GitHub::Verifier.load(key) }
      config.serialize_into_session { |user| Warden::GitHub::Verifier.dump(user) }
    end

    helpers do
      def production?
        !! ENV['PRODUCTION']
      end

      def masters
        file_path = File.expand_path(File.dirname(__FILE__) + '/monkeys.txt')
        @monkeys ||= File.open(file_path, 'r').readlines.map(&:chomp).sort
      end
    end

    get '/' do
      haml :index, :layout => :_base, :locals => {:monkeys => masters}
    end

    get '/profile' do
      unless env['warden'].user
        redirect to('/')
      else
        haml :profile, :layout => :_base,
                       :locals => {
                          :user => env['warden'].user,
                          :monkeys => masters,
                        }
      end
    end

    get '/login' do
      env['warden'].authenticate!
      redirect to('/profile')
    end

    get '/github/authenticate' do
      puts request.inspect
      env['warden'].authenticate!

      if session[:jenkins] && env['warden'].user
        session[:jenkins] = nil
        redirect_path = "securityRealm/finishLogin?from=%2Fblue&#{env['QUERY_STRING']}"
        href = "http://localhost:8080/#{redirect_path}"
        login = env['warden'].user.login
        if production?
          href = "http://#{login}.codevalet.io/#{redirect_path}"
        end
        redirect to(href)
      end
      redirect '/profile'
    end

    get '/_to/jenkins' do
      unless env['warden'].user
        redirect to('/')
      end
      session[:jenkins] = true
      login = env['warden'].user.login
      redirect_path = 'securityRealm/commenceLogin?from=%2Fblue'
      href = "http://localhost:8080/#{redirect_path}"
      if production?
        href = "http://#{login}.codevalet.io/#{redirect_path}"
      end
      redirect to(href)
    end

    get '/github/logout' do
      session[:oauthcode] = nil
      env['warden'].logout
      redirect '/'
    end
  end
end
