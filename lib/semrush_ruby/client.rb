require 'forwardable'
require 'multi_json'
require 'faraday_middleware/response_middleware'

module SemrushRuby
  class CSVParsingMiddleware < FaradayMiddleware::ResponseMiddleware
    attr_accessor :parser_options

    dependency do
      require 'csv' unless defined?(::CSV)
    end

    define_parser do |body, opts|
      ::CSV.parse(body, opts) unless body.strip.empty?
    end

    def initialize(app = nil, options = {})
      super(app, options)
      @parser_options = options[:parser_options] || {}
    end

    def parse(body)
      #if self.class.parser
        #begin
          self.class.parser.call(body, @parser_options)
        #rescue StandardError, SyntaxError => err
          #raise err if err.is_a? SyntaxError and err.class.name != 'Psych::SyntaxError'
          #raise Faraday::Error::ParsingError, err
        #end
      #else
        #body
      #end
    end
  end
  class Client

    attr_accessor :api_key, :api_url, :last_request, :last_response, :page_size

    def initialize(options={})
      @api_url = options[:api_url] || SemrushRuby.api_url
      @api_key = options[:api_key] || SemrushRuby.api_key
      @page_size = options[:page_size] || 100
    end

    def connection
      @connection ||= Faraday.new(url: @api_url, params: default_params, headers: default_headers) do |f|
        f.request :url_encoded
        f.use FaradayMiddleware::Mashify
        # TODO : the transfer encoding says chunked but does not provide a chunk len - is it really chunked?
        # f.use FaradayMiddleware::Chunked
        f.use SemrushRuby::CSVParsingMiddleware, parser_options: {headers: true, col_sep: ';'}
        f.use FaradayMiddleware::FollowRedirects
        f.adapter Faraday.default_adapter
      end
    end

    def request(verb, path, options)
      connection.send(verb) do |req|
        case verb
        when :get, :delete
          req.url(path, options)
        when :post, :patch
          req.url path
          req.body = options
        else
          nil
        end
        self.last_request = req
      end.tap{|resp| self.last_response = resp}.body
    end

    def get(path, options)
      request(:get, path, options)
    end

    def backlinks_overview domain, options = {}
      get('/analytics/v1', type: 'backlinks_overview', target: domain, target_type: determine_target_type(domain, options))
    end

    def backlinks domain, options = {}
      # TODO : build in a :all feature that pulls all pages and combines
      options = set_offset_and_limit_from_page_param(options)
      get('/analytics/v1',
          type: 'backlinks',
          target: domain,
          target_type: determine_target_type(domain, options),
          display_limit: options[:limit] || page_size,
          display_offset: options[:offset] || 0,
         )
    end

    def backlinks_domains domain, options = {}
      # TODO : build in a :all feature that pulls all pages and combines
      options = set_offset_and_limit_from_page_param(options)
      get('/analytics/v1',
          type: 'backlinks_refdomains',
          target: domain,
          target_type: determine_target_type(domain, options),
          display_limit: options[:limit] || page_size,
          display_offset: options[:offset] || 0,
         )
    end
    alias_method :backlinks_refdomains, :backlinks_domains


    private

    def determine_target_type domain, options = {}
      return options[:target_type] if options.has_key?(:target_type)
      require 'uri'
      begin
        uri = URI(domain)
        uri.scheme.nil? ? 'root_domain' : ((uri.path.length > 0 || uri.query) ? 'url' : 'domain')
      rescue
        'root_domain'
      end
    end

    # FIXME : feature envy, we need some object the represents options that can do this
    def set_offset_and_limit_from_page_param options
      return options unless options.has_key?(:page)
      options[:offset] = options[:page].to_i * self.page_size - self.page_size
      options[:limit] = self.page_size + options[:offset]
      options
    end

    def default_headers
      {
        accept: 'text/plain',
        user_agent: "SemrushRuby #{SemrushRuby::VERSION}"
      }
    end

    def default_params
      {key: @api_key}
    end
  end
end
