$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'dotenv'
Dotenv.load

require 'semrush_ruby'
require 'vcr'
require 'byebug'

VCR.configure do |c| #{{{1
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end

RSpec.configure do |config|
  config.expect_with(:rspec) { |expectations| expectations.include_chain_clauses_in_custom_matcher_descriptions = true }
  config.mock_with(:rspec) { |mocks| mocks.verify_partial_doubles = true }

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.disable_monkey_patching!
  config.warnings = true
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.profile_examples = 10
  config.order = :random
  Kernel.srand config.seed
end
