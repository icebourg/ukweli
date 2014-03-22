require 'sinatra'
require 'erb'
require_relative './lib/elasticsearch.rb'
require_relative './lib/helpers.rb'

class Ukweli < Sinatra::Base
  helpers Sinatra::Ukweli::Helpers

  configure do
    ES = ElasticSearch.new()
  end

  get '/' do
    erb :index
  end

  post '/search' do
    @terms = params[:search]

    documents = ES.search(@terms)
    @results   = []

    # erm, don't blame me for this. I only work here!
    documents['hits']['hits'].each do |document|
      source   = document['_source']

      versetext = source['text']
      reference = "#{source['book'].strip} #{source['chapter']}:#{source['verse']}"

      @results << {
        'reference' => reference,
        'versetext' => versetext
      }
    end
    erb :results
  end

  get '/:index/:id' do
    reference = params[:id].gsub(/_/, ' ').gsub(/-/, ' ').gsub(/\./, ' ')
    document = ES.get(params[:index], reference)
    source   = document['_source']

    @versetext = source['text']
    @reference = "#{source['book'].strip} #{source['chapter']}:#{source['verse']}"
    erb :verse
  end
end