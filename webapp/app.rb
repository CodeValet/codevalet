#!/usr/bin/env ruby

require 'securerandom'
require 'yaml'

require 'dalli'
require 'haml'
require 'rack/session/dalli'
require 'sinatra/base'
require 'warden/github'

require 'codevalet/webapp/authfailure'
require 'codevalet/webapp/monkeys'
require 'codevalet/webapp/plugins'

Haml::TempleEngine.disable_option_validator!

module CodeValet
  # Primary web application for CodeValet.io
  class App < Sinatra::Base
    include Warden::GitHub::SSO

    ADMINISTRATORS = %w(rtyler).freeze

    enable  :sessions
    set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }

    enable  :raise_errors

    if ENV['PRODUCTION']
      disable :show_exceptions
    end

    set :public_folder, File.dirname(__FILE__) + '/assets'

    configure do
      if ENV['PRODUCTION'] || ENV['USE_MEMCACHED']
        use Rack::Session::Dalli,
          :namespace => 'webapp.sessions',
          :cache => Dalli::Client.new(ENV.fetch('MEMCACHED_SERVER') { 'cache:11211' })
      end
    end

    use Warden::Manager do |config|
      config.failure_app = CodeValet::WebApp::AuthFailure
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
        return CodeValet::WebApp::Monkeys.data
      end

      def admin?
        return false unless env['warden'].user
        return ADMINISTRATORS.include? env['warden'].user.login
      end
    end

    get '/' do
      haml :index, :layout => :_base, :locals => {:monkeys => masters}
    end

    get '/doc' do
      haml :doc, :layout => :_base
    end

    get '/abuse' do
      haml :abuse, :layout => :_base
    end

    get '/profile' do
      unless env['warden'].user
        redirect to('/')
      else
        haml :profile, :layout => :_base,
                       :locals => {
                          :user => env['warden'].user,
                          :monkeys => masters,
                          :admin => admin?,
                        }
      end
    end

    get '/login' do
      env['warden'].authenticate!
      redirect to('/profile')
    end

    get '/github/authenticate' do
      env['warden'].authenticate!

      if session[:jenkins] && env['warden'].user
        session[:jenkins] = nil
        redirect_path = "securityRealm/finishLogin?from=%2Fblue&#{env['QUERY_STRING']}"
        href = "http://localhost:8080/#{redirect_path}"
        login = env['warden'].user.login
        if production?
          if session[:admin_instance]
            login = session[:admin_instance]
            session[:admin_instance] = nil
          end
          href = "https://#{login}.codevalet.io/#{redirect_path}"
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
        if admin? && params['instance']
          login = params['instance']
          session[:admin_instance] = login
        end
        href = "https://#{login}.codevalet.io/#{redirect_path}"
      end
      redirect to(href)
    end

    get '/github/logout' do
      env['warden'].logout
      redirect '/'
    end
  end
end
