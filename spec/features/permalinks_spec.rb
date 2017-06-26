# frozen_string_literal: true
require 'rails_helper'

describe 'permalinks' do
  before do
    Rails.application.config.application_root_url = 'http://my.url'
  end

  describe 'concerns' do
    let(:work_type) { "generic_work" }
    let(:work) { create(:generic_work_with_one_file, title: ["Magnificent splendor"], alt_description: "My description", source: ["The Internet"], based_near: ["USA"], user: user) }
    let(:user) { create(:user) }
    let(:work_path) { "/concern/#{work_type}s/#{work.id}" }
    let(:file_path) { "/concern/parent/#{work.id}/file_sets/#{work.file_sets.first.id}" }

    before do
      sign_in user
    end

    describe 'work show page' do
      before do
        visit work_path
      end
      it "displays a permanent link to the work" do
        expect(page).to have_content "Permanent link to this page: http://my.url/show/#{work.id}"
      end
    end

    describe 'file show page' do
      before do
        visit file_path
      end
      it "displays a permanent link to the attached file" do
        expect(page).to have_content "Permanent link to this page: http://my.url/show/#{work.file_sets.first.id}"
      end
    end
  end

  describe 'collections' do
    let(:user) { create(:user) }
    let(:collection) { create(:public_collection, user: user) }
    let(:collection_path) { "/collections/#{collection.id}" }

    before do
      sign_in user
      visit collection_path
    end

    it "displays a link to the collection" do
      expect(page).to have_content "Link to this page: http://my.url/collections/#{collection.id}"
    end
  end

  describe 'user profiles' do
    let(:user) { create(:user) }
    let(:profile_path) { hyrax.profile_path(user.to_param) }

    before do
      sign_in user
      visit profile_path
    end

    it "displays a link to the user's profile" do
      expect(page).to have_content "Link to this page: http://my.url#{profile_path}"
    end
  end
end
