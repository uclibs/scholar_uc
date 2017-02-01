# frozen_string_literal: true
require 'rails_helper'

describe 'Adding an infected file', js: true do
  let(:user) { FactoryGirl.create(:user) }

  before do
    allow(CharacterizeJob).to receive(:perform_later)
    allow(Hydra::Works::VirusCheckerService).to receive(:file_has_virus?).and_return(true)
    login_as user
  end

  shared_examples 'infected submission' do
    it 'drops the file(s) before saving the work and alerts the user' do
      click_link "Files" # switch tab
      expect(page).to have_content "Add files"
      attach_file("files[]", File.dirname(__FILE__) + "/../../spec/fixtures/image.jp2", visible: false)
      click_link "Description" # switch tab
      fill_in('Title', with: 'My Infected Work')
      fill_in('Creator', with: 'Test User')
      fill_in('Keyword', with: 'tests')
      select 'Attribution-ShareAlike 3.0 United States', from: 'generic_work_rights'
      choose('generic_work_visibility_open')
      check('agreement')
      check('agreement') # need to check the box again sometimes (Capybara flakiness)
      click_on('Save') if page.has_button?('Save')
      click_on('Save') if page.has_button?('Save') # need to click Save again sometimes (Capybara flakiness)
      expect(page).to have_content('My Infected Work')
      expect(page).to have_content('A virus was detected in a file you uploaded.')
    end
  end

  context 'to an existing work', js: true do
    let(:work) { FactoryGirl.build(:work, user: user, title: ['My Infected Work']) }
    let(:file_set) { FactoryGirl.create(:file_set, user: user, title: ['ABC123xyz']) }

    before do
      work.ordered_members << file_set
      work.read_groups = []
      work.save!
      visit edit_curation_concerns_generic_work_path(work)
    end
    it_behaves_like 'infected submission'
  end

  context 'to a new work', js: true do
    before do
      visit new_curation_concerns_generic_work_path
    end
    it_behaves_like 'infected submission'
  end
end
