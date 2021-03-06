# frozen_string_literal: true
require 'rails_helper'

describe "Sending an email via the contact form", type: :feature do
  describe "with unauthenticated user" do
    it "shows recaptcha dialog" do
      visit '/'
      within '.spec-flag' do
        click_link "Contact"
      end
      expect(page).to have_css('div.g-recaptcha')
    end
  end

  describe "with authenticated user" do
    before { sign_in(:user) }

    it "does not show recaptcha dialog" do
      visit '/'
      within '.spec-flag' do
        click_link "Contact"
      end
      expect(page).not_to have_css('div.g-recaptcha')
    end

    it "sends mail" do
      visit '/'
      within '.spec-flag' do
        click_link "Contact"
      end
      expect(page).to have_content "Contact the Scholar@UC Team"
      fill_in "Your Name", with: "Test McPherson"
      fill_in "Your Email", with: "archivist1@example.com"
      fill_in "Message", with: "I am contacting you regarding ScholarSphere."
      fill_in "Subject", with: "My Subject is Cool"
      click_button "Send"
      expect(page).to have_content "Thank you for your message!"
    end
  end
end
