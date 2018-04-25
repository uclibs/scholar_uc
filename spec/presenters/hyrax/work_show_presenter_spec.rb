# frozen_string_literal: true
require 'rails_helper'

describe Hyrax::WorkShowPresenter do
  let(:solr_document) { SolrDocument.new(work.to_solr) }
  let(:presenter) { described_class.new(solr_document, ability) }

  subject { described_class.new(double, double) }
  it { is_expected.to delegate_method(:based_near).to(:solr_document) }
  it { is_expected.to delegate_method(:related_url).to(:solr_document) }
  it { is_expected.to delegate_method(:depositor).to(:solr_document) }
  it { is_expected.to delegate_method(:identifier).to(:solr_document) }
  it { is_expected.to delegate_method(:resource_type).to(:solr_document) }
  it { is_expected.to delegate_method(:keyword).to(:solr_document) }
  it { is_expected.to delegate_method(:itemtype).to(:solr_document) }

  describe 'stats_path' do
    let(:user) { 'sarah' }
    let(:ability) { double "Ability" }
    let(:work) { build(:generic_work, id: '123abc') }
    it { expect(presenter.stats_path).to eq Hyrax::Engine.routes.url_helpers.stats_work_path(id: work) }
  end

  describe '#itemtype' do
    let(:work) { build(:generic_work, resource_type: type) }
    let(:ability) { double "Ability" }

    subject { presenter.itemtype }

    context 'when resource_type is Audio' do
      let(:type) { ['Audio'] }

      it do
        is_expected.to eq 'http://schema.org/AudioObject'
      end
    end

    context 'when resource_type is Conference Proceeding' do
      let(:type) { ['Conference Proceeding'] }

      it { is_expected.to eq 'http://schema.org/ScholarlyArticle' }
    end
  end

  describe 'admin users' do
    let(:user)    { create(:user) }
    let(:ability) { Ability.new(user) }
    let!(:work)   { build(:public_generic_work) }

    before { allow(user).to receive_messages(groups: ['admin', 'registered']) }

    context 'with a new public work' do
      it 'can feature the work' do
        allow(user).to receive(:can?).with(:create, FeaturedWork).and_return(true)
        expect(presenter.display_feature_link?).to be true
        expect(presenter.display_unfeature_link?).to be false
      end
    end

    context 'with a featured work' do
      before { FeaturedWork.create(work_id: work.id) }
      it 'can unfeature the work' do
        expect(presenter.display_feature_link?).to be false
        expect(presenter.display_unfeature_link?).to be true
      end
    end

    describe "#editor?" do
      subject { presenter.editor? }
      it { is_expected.to be true }
    end
  end

  describe ManifestPresenter do
    let(:document) { { "has_model_ssim" => ['GenericWork'], 'id' => '99' } }
    let(:solr_document) { SolrDocument.new(document) }
    let(:request) { double(base_url: 'http://test.host') }
    let(:ability) { nil }
    let(:presenter) { Hyrax::WorkShowPresenter.new(solr_document, ability, request) }

    describe "#manifest_url" do
      subject { presenter.manifest_url }
      it { is_expected.to eq 'http://test.host/concern/generic_works/99/manifest' }
    end

    describe "representative_presenter" do
      subject do
        presenter.representative_presenter
      end

      let(:work) { FactoryBot.create(:generic_work_with_one_file) }
      let(:document) { work.to_solr }

      before do
        work.representative_id = work.file_sets.first.id
      end
      it "returns a presenter" do
        expect(subject).to be_kind_of Hyrax::FileSetPresenter
      end
    end

    describe "#download_url" do
      subject { presenter.download_url }

      let(:solr_document) { SolrDocument.new(work.to_solr) }
      let(:request) { double(host: 'example.org') }

      context "with a representative" do
        let(:work) { create(:work_with_representative_file) }

        it { is_expected.to eq "http://#{request.host}/downloads/#{work.representative_id}" }
      end

      context "without a representative" do
        let(:work) { create(:work) }

        it { is_expected.to eq '' }
      end
    end
  end

  describe '#members_include_viewable_image?' do
    let(:user_key) { 'a_user_key' }
    let(:attributes) do
      { "id" => '888888',
        "title_tesim" => ['foo', 'bar'],
        "human_readable_type_tesim" => ["Generic Work"],
        "has_model_ssim" => ["GenericWork"],
        "date_created_tesim" => ['an unformatted date'],
        "depositor_tesim" => user_key }
    end
    let(:solr_document) { SolrDocument.new(attributes) }
    let(:request) { double(host: 'example.org', base_url: 'http://example.org') }
    let(:ability) { double Ability }
    let(:presenter) { described_class.new(solr_document, ability, request) }
    let(:file_set_presenter) { Hyrax::FileSetPresenter.new(solr_document, ability) }
    let(:member_presenters) { [file_set_presenter] }

    subject { presenter.members_include_viewable_image? }

    before do
      allow(presenter).to receive(:member_presenters).and_return(member_presenters)
      allow(ability).to receive(:can?).with(:read, solr_document.id).and_return(read_permission)
    end

    context 'when the work has at least one viewable image' do
      let(:read_permission) { true }

      it { is_expected.to be true }
    end

    context 'when the work has no viewable images' do
      let(:read_permission) { false }

      it { is_expected.to be false }
    end
  end
end
