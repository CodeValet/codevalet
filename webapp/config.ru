ENV['RACK_ENV'] ||= 'development'

$LOAD_PATH << File.dirname(__FILE__)

require 'app'
require 'raven'

use Rack::Static, :urls => ["/css", "/img", "/js"], :root => "public"
use Raven::Rack

run CodeValet::App
