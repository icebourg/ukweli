require 'elasticsearch'
# helps make persistent connections to ES
#require 'patron'

class ElasticSearch
  def initialize #(args)
    #@host      = args.fetch(:host) { "localhost" }
    #@port      = args.fetch(:port) { "9200" }
    connection
  end

  def get(index, id)
    @esclient.get(:index => index, :id => id)
  end

  def search(terms, index='web')
    @esclient.search(:index => index, :q => "text:#{terms}")
  end

  private
  attr_reader :esclient
  def connection
    @esclient = Elasticsearch::Client.new log: true
  end
end
