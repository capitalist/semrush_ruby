require "semrush_ruby/version"
require 'faraday'
require 'faraday_middleware'

module SemrushRuby
  class << self
    attr_accessor :api_url, :api_key

    def configure
      reset_defaults!
      yield self if block_given?
    end

    def reset_defaults!
      @api_url = ENV['SEMRUSH_URL'] || 'http://api.semrush.com/'
      @api_key = ENV['SEMRUSH_KEY']
    end
  end
end

SemrushRuby.configure
require 'semrush_ruby/client'
