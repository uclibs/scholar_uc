# frozen_string_literal: true
require 'rails_helper'

shared_examples 'work crud' do |work|
  let(:work_type) { work.name.underscore }

  before { allow_any_instance_of(Ability).to receive(:user_is_etd_manager).and_return(true) }

  it 'can view the new work form' do
    visit hyrax.root_path
    click_on 'New Work'
    expect(page).to have_content(work.human_readable_type)
  end

  it 'can see the license wizard on the new work form', js: true do
    visit send("new_hyrax_#{work_type}_path")
    expect(page).to have_content('License Wizard')
  end

  it 'can submit a new work' do
    visit send("new_hyrax_#{work_type}_path")
    within '.tab-content' do
      fill_in('Title', with: 'My Test Work', match: :first)

      if work == Document || work == GenericWork || work == Image || work == Medium
        fill_in('Description', with: 'This is a description.')
        fill_in('Creator', with: 'Test User')
      elsif work == Etd
        fill_in('Abstract', with: 'This is an abstract.')
        fill_in('Creator', with: 'Test User')
        fill_in('Advisor', with: 'Ima Advisor')
      elsif work == StudentWork
        fill_in('Description', with: 'This is an abstract.')
        fill_in('Creator', with: 'Test User')
        fill_in('Advisor', with: 'Ima Advisor')
      elsif work == Article
        fill_in('Abstract', with: 'This is an abstract.')
        fill_in('Author', with: 'Test User')
      else
        fill_in('Description', with: 'This is a description.')
        fill_in('Required Software', with: 'This is Required Software.')
        fill_in('Creator', with: 'Test User')
      end
    end
    click_on 'Files'
    attach_file("files[]", Rails.root + "spec/fixtures/test_file.txt", visible: false)
    click_on 'Save'
    expect(page).to have_content 'Your files are being processed by Scholar@UC in the background. The metadata and access controls you specified are being applied.'
  end

  it 'can submit a new work without files' do
    visit send("new_hyrax_#{work_type}_path")
    within '.tab-content' do
      fill_in('Title', with: 'My new work', match: :first)

      if work == Document || work == GenericWork || work == Image || work == Medium
        fill_in('Description', with: 'This is a description.')
        fill_in('Creator', with: 'Test User')
      elsif work == Etd
        fill_in('Abstract', with: 'This is an abstract.')
        fill_in('Creator', with: 'Test User')
        fill_in('Advisor', with: 'Ima Advisor')
      elsif work == StudentWork
        fill_in('Description', with: 'This is an abstract.')
        fill_in('Creator', with: 'Test User')
        fill_in('Advisor', with: 'Ima Advisor')
      elsif work == Article
        fill_in('Abstract', with: 'This is an abstract.')
        fill_in('Author', with: 'Test User')
      else
        fill_in('Description', with: 'This is a description.')
        fill_in('Required Software', with: 'This is Required Software.')
        fill_in('Creator', with: 'Test User')
      end

      select('All rights reserved', from: "#{work_type}_rights")
    end
    click_on 'Save'
    expect(page).to have_content 'Your files are being processed by Scholar@UC in the background. The metadata and access controls you specified are being applied.'
  end

  it 'can delete a work it owns' do
    visit hyrax.dashboard_works_path
    within '#document_' + deleted_work.id.to_s do
      click_on 'Delete Work'
    end
    expect(page).to have_content 'Deleted'
  end
end

describe 'end to end behavior:', :workflow do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:persisted_work) { FactoryGirl.create(:work, user: user) }
  let!(:deleted_work) { FactoryGirl.create(:work, user: user) }
  let!(:collection) { FactoryGirl.create(:collection, user: user) }
  before do
    create(:permission_template_access,
           :deposit,
           permission_template: create(:permission_template, with_admin_set: true),
           agent_type: 'user',
           agent_id: user.user_key)
    login_as user
  end
  context 'the user' do
    it 'can login to the application' do
      logout
      visit new_user_session_path
      within '.new_user' do
        fill_in('Email', with: user.email)
        fill_in('Password', with: user.password)
        click_on('Log in')
      end
      expect(page).to have_content('Signed in successfully')
    end

    it 'can view the dashboard' do
      visit hyrax.dashboard_index_path
      expect(page).to have_content 'My Dashboard'
    end

    it 'can view the my collections view' do
      visit hyrax.dashboard_collections_path
      expect(page).to have_content 'Collections listing'
    end

    it 'can create a new collection' do
      visit new_collection_path
      fill_in('Title', with: 'My Test Collection')
      click_on 'Create Collection'
      expect(page).to have_content 'Collection was successfully created.'
    end

    it 'can view the my works view' do
      visit hyrax.dashboard_works_path
      expect(page).to have_content 'Works listing'
    end

    it_behaves_like 'work crud', GenericWork
    it_behaves_like 'work crud', Article
    it_behaves_like 'work crud', Document
    it_behaves_like 'work crud', Dataset
    it_behaves_like 'work crud', Image
    it_behaves_like 'work crud', Medium
    it_behaves_like 'work crud', StudentWork
    it_behaves_like 'work crud', Etd

    # TODO: update this spec once we get the fix for scholar_uc#907 from hyrax.
    # needs to verify specific collection is being updated, for now
    it 'can add a work it owns to collection' do
      skip 'need to fix display bug' do
      end
    end
  end
end

#
# end to end notes:
#
#
