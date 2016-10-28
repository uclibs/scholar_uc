# frozen_string_literal: true

require 'rails_helper'

describe 'Batch creation of works', type: :feature do
  let(:user) { FactoryGirl.create(:user) }

  before do
    login_as user
  end

  it "renders the batch create form" do
    visit sufia.new_batch_upload_path
    within("li.active") do
      expect(page).to have_content("Files")
    end
    expect(page).to have_content("Each file will be uploaded to a separate new work resulting in one work per uploaded file.")
  end
end