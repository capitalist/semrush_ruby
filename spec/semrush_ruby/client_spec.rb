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

  context 'backlinks_domains' do
    let(:domain) { 'github.com' }
    let(:result) { subject.backlinks_domains(domain, limit: 10) }

    it 'returns backlinks for github.com' do
      VCR.use_cassette('github_com_backlink_domains') do
        # TODO : the resulting CSV::Table should be decomposed into structs for easier digestion
        expect(result['source_title'].count).to eq(10)
      end
    end
  end

  context 'target_type detection' do
    let(:result) { subject.backlinks_domains(domain, limit: 10) }

    context 'when there is no uri scheme' do
      let(:domain) { 'github.com' }
      it 'it uses root_domain' do
        expect(subject).to receive(:get).with('/analytics/v1', type: 'backlinks_refdomains', target: domain, target_type: 'root_domain', display_limit: 10, display_offset: 0)
        result
      end
    end
    context 'when there is a subdomain' do
      let(:domain) { 'http://www.github.com' }
      it 'uses domain' do
        expect(subject).to receive(:get).with('/analytics/v1', type: 'backlinks_refdomains', target: domain, target_type: 'domain', display_limit: 10, display_offset: 0)
        result
      end
    end
    context 'when there is a path' do
      let(:domain) { 'http://www.github.com/some-path' }
      it 'uses url' do
        expect(subject).to receive(:get).with('/analytics/v1', type: 'backlinks_refdomains', target: domain, target_type: 'url', display_limit: 10, display_offset: 0)
        result
      end
    end
    context 'when there is a query' do
      let(:domain) { 'http://www.github.com/?q=some-path' }
      it 'uses url' do
        expect(subject).to receive(:get).with('/analytics/v1', type: 'backlinks_refdomains', target: domain, target_type: 'url', display_limit: 10, display_offset: 0)
        result
      end
    end
  end

  context 'pagination' do
    before { subject.page_size = 10 }

    context 'when there is no page provided' do
      let(:result) { subject.backlinks_domains(domain) }
      let(:domain) { 'github.com' }
      it 'it uses an offset of 0 and a limit equal to the page size' do
        expect(subject).to receive(:get).with('/analytics/v1', type: 'backlinks_refdomains', target: domain, target_type: 'root_domain', display_limit: 10, display_offset: 0)
        result
      end
    end

    context 'when page is set to 1' do
      let(:result) { subject.backlinks_domains(domain, page: 1) }
      let(:domain) { 'github.com' }
      it 'it uses an offset of 0 and a limit equal to the page size' do
        expect(subject).to receive(:get).with('/analytics/v1', type: 'backlinks_refdomains', target: domain, target_type: 'root_domain', display_limit: 10, display_offset: 0)
        result
      end
    end

    context 'when page is set to 2' do
      let(:result) { subject.backlinks_domains(domain, page: 2) }
      let(:domain) { 'github.com' }
      it 'it uses an offset of 10 and a limit equal to the page size plus the offset' do
        expect(subject).to receive(:get).with('/analytics/v1', type: 'backlinks_refdomains', target: domain, target_type: 'root_domain', display_limit: 20, display_offset: 10)
        result
      end
    end

    pending 'when the :all option is passed'

  end
end
