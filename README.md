# SemrushRuby

This is a Ruby API client for the SEMRush API. 

It currently only supports backlinks_overview and backlinks because that's what I need for my current project. However, I intend to build out support of the entire SEMRush API for completeness and as a way of learing the API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'semrush_ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install semrush_ruby

## Usage

Set your SEMRush API key in your environment as SEMRUSH_KEY

```ruby
client = SemrushRuby::Client.new
client.backlinks_overview 'github.com'
```

The result will be parsed into a CSV::Table from the SEMRush API response.

If you'd like to see the raw request or response, you can do:
```ruby
client.last_request
client.last_response
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/semrush_ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
