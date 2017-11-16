# frozen_string_literal: true
require 'rails_helper'

require 'iiif_manifest'
RSpec.describe Hyrax::FileSetPresenter do
  let(:file_set) { FactoryBot.create(:file_set) }
  let(:solr_document) { SolrDocument.new(file_set.to_solr) }
  let(:request) { double(base_url: 'http://test.host') }
  let(:presenter) { described_class.new(solr_document, nil, request) }
  let(:id) { CGI.escape(file_set.original_file.id) }
  let(:file) { File.open(File.join(fixture_path, 'world.png')) }

  before do
    Hydra::Works::AddFileToFileSet.call(file_set,
                                        file,
                                        :original_file)
  end

  describe "display_image" do
    subject { presenter.display_image }
    it "creates a display image" do
      expect(subject).to be_instance_of IIIFManifest::DisplayImage
      expect(subject.url).to eq "http://test.host/images/#{id}/full/600,/0/default.jpg"
    end
  end

  describe "iiif_endpoint" do
    subject { presenter.send(:iiif_endpoint, file_set.original_file) }
    it 'returns the url' do
      expect(subject.url).to eq "http://test.host/images/#{id}"
    end
  end
end
