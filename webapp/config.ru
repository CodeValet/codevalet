ENV['RACK_ENV'] ||= 'development'

$LOAD_PATH << File.dirname(__FILE__)

require 'app'

use Rack::Static, :urls => ["/css", "/img", "/js"], :root => "public"

run CodeValet::App
