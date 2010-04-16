#!/usr/bin/env ruby
require 'json'
require 'yaml'
require 'active_support' # Hash.to_options and Hash.to_xml
require 'sinatra'
require 'rack/cache'
gem 'sinatra', '~> 1'

CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), "config.yml"))

require 'lib/amazon'

class App < Sinatra::Base
  use Rack::Cache, CONFIG['cache']

  after do
    ttl = CONFIG['cache']['ttl']
    expires ttl, :public
  end

  #
  # Converts given array to a Hash
  #
  def to_hash(array)
    array.map do |item| 
      Hash.from_xml("<root>#{item.elem.inner_html}</root>")['root']
    end
  end

  get '/' do
    callback = params.delete('callback') # jsonp
    json = to_hash(AmazonAWS.search(params.to_options)).to_json

    if callback
      content_type :js
      response = "#{callback}(#{json})" 
    else
      content_type :json
      response = json
    end
    response
  end
end

App.run! if __FILE__ == $0
