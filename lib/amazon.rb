require 'amazon/ecs'

class ApiException < RuntimeError; end

Amazon::Ecs.debug = CONFIG['amazon']['debug']
Amazon::Ecs.options = {
  :aWS_access_key_id => CONFIG['amazon']['key'], 
  :aWS_secret_key => CONFIG['amazon']['secret']
}

class AmazonAWS
  class << self 
    #
    # http://docs.amazonwebservices.com/AWSEcommerceService/4-0/ApiReference/ItemSearchOperation.html
    #
    def search(options)
      res = Amazon::Ecs.item_search(options[:keywords], options)
      raise ApiException.new(res.error) if res.has_error?
      return res.items
    end
  end
end
