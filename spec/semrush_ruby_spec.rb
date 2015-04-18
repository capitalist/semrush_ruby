require 'spec_helper'

RSpec.describe SemrushRuby do
  it 'has a version number' do
    expect(SemrushRuby::VERSION).not_to be nil
  end

  describe 'configuration' do
    context 'defaults' do
      let(:client) { SemrushRuby::Client.new }
      it 'uses the default api url' do
        expect(client.api_url).to eq('http://api.semrush.com/')
      end
    end

    context 'as a client option' do
      let(:client) { SemrushRuby::Client.new api_url: 'http://test.semrush.com/' }
      it 'uses the passed in api url' do
        expect(client.api_url).to eq('http://test.semrush.com/')
      end
    end

    context 'as a module var' do
      before do
        SemrushRuby.configure do |sr|
          sr.api_url = 'http://other.semrush.com/'
        end
      end

      after do
        SemrushRuby.reset_defaults!
      end
      let(:client) { SemrushRuby::Client.new }

      it 'uses the default api url' do
        expect(client.api_url).to eq('http://other.semrush.com/')
      end

    end
  end
end
