require 'bundler'
Bundler.require :default
require './web'
require 'json'
$stdout.sync = true
use Rack::Parser, :content_types => {
  'application/json'  => Proc.new { |body| JSON.parse body }
}

run Sinatra::Application