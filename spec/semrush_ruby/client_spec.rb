require 'spec_helper'

RSpec.describe SemrushRuby::Client do
  before { SemrushRuby.configure {|sr| sr.api_key = 'change-this-to-your-real-key' }}
  after { SemrushRuby.reset_defaults! }

  context 'backlinks_overview' do
    let(:domain) { 'github.com' }
    let(:result) { subject.backlinks_overview(domain) }

    it 'returns backlink overview data for github.com' do
      VCR.use_cassette('github_com_backlinks_overview') do
        # TODO : the resulting CSV::Table should be decomposed into structs for easier digestion
        expect(result['total']).to eq(['44888154'])
      end
    end

  end

  context 'backlinks' do
    let(:domain) { 'github.com' }
    let(:result) { subject.backlinks(domain, limit: 10) }

    it 'returns backlinks for github.com' do
      VCR.use_cassette('github_com_backlinks') do
        # TODO : the resulting CSV::Table should be decomposed into structs for easier digestion
        expect(result['source_title'].count).to eq(10)
      end
    end
  end
end
