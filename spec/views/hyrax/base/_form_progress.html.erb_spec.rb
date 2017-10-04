# frozen_string_literal: true
require 'rails_helper'

describe 'hyrax/base/_form_progress.html.erb', type: :view do
  let(:ability) { double }
  let(:user) { stub_model(User) }

  before do
    Hyrax.config.work_requires_files = false
    allow(controller).to receive(:current_user).and_return(user)
  end

  let(:page) do
    view.simple_form_for form do |f|
      render 'hyrax/base/form_progress', f: f
    end
    Capybara::Node::Simple.new(rendered)
  end

  context "when creating batch works" do
    let(:work) { GenericWork.new }
    let(:form) do
      Hyrax::Forms::BatchUploadForm.new(work, ability, controller)
    end

    before do
      allow(view).to receive(:batch_uploads_path).and_return("/batch_uploads")
    end

    it "doesn't allow cloud uploads" do
      expect(page).not_to have_content 'Add Files from Cloud Providers'
    end

    it "requires files to be attached" do
      expect(page).to have_content 'Add files'
    end
  end

  context "when creating single works" do
    let(:work) { GenericWork.new }
    let(:form) do
      Hyrax::GenericWorkForm.new(work, ability, controller)
    end

    it "does not require files to be attached" do
      expect(page).not_to have_content 'Add files'
    end
  end

  context "for a new object" do
    before { assign(:form, form) }

    let(:work) { GenericWork.new }
    let(:form) do
      Hyrax::GenericWorkForm.new(work, ability, controller)
    end

    context "with options for proxy" do
      let(:proxies) { [stub_model(User, email: 'bob@example.com')] }
      before do
        allow(user).to receive(:can_make_deposits_for).and_return(proxies)
      end
      it "shows options for proxy" do
        expect(page).to have_content 'On behalf of'
        expect(page).to have_selector("select#generic_work_on_behalf_of option[value=\"\"]", text: 'Yourself')
        expect(page).to have_selector("select#generic_work_on_behalf_of option[value=\"bob@example.com\"]")
      end
    end

    context "without options for proxy" do
      let(:proxies) { [] }
      before do
        allow(user).to receive(:can_make_deposits_for).and_return(proxies)
      end
      it "doesn't show options for proxy" do
        expect(page).not_to have_content 'On behalf of'
        expect(page).not_to have_selector 'select#generic_work_on_behalf_of'
      end
    end

    context "with active deposit agreement" do
      it "shows accept text" do
        expect(page).to have_content 'I have read and agree to the'
        expect(page).to have_link 'Deposit Agreement', href: '/agreement'
        expect(page).not_to have_selector("#agreement[checked]")
      end
    end

    context "with passive deposit agreement" do
      before do
        allow(Flipflop).to receive(:active_deposit_agreement_acceptance?)
          .and_return(false)
      end
      it "shows accept text" do
        expect(page).to have_content 'By saving this work I agree to the'
        expect(page).to have_link 'Deposit Agreement', href: '/agreement'
      end
    end

    context "with no deposit agreement" do
      before do
        allow(Flipflop).to receive(:show_deposit_agreement?).and_return(false)
      end
      it "does not display active accept text" do
        expect(page).not_to have_content 'I have read and agree to the'
        expect(page).not_to have_selector("#agreement[checked]")
      end
      it "does not display passive accept text" do
        expect(page).not_to have_content 'By saving this work I agree to the'
        expect(page).not_to have_link 'Deposit Agreement', href: '/agreement'
      end
    end
  end

  context "when the work has been saved before" do
    before do
      # TODO: stub_model is not stubbing new_record? correctly on ActiveFedora models.
      allow(work).to receive(:new_record?).and_return(false)
      assign(:form, form)
    end

    let(:work) { stub_model(GenericWork, id: '456', etag: '123456') }
    let(:form) do
      Hyrax::GenericWorkForm.new(work, ability, controller)
    end

    it "renders the deposit agreement already checked and the version" do
      expect(page).to have_selector("#agreement[checked]")
      expect(page).to have_selector("input#generic_work_version[value=\"123456\"]", visible: false)
      expect(page).to have_link("Cancel", href: "/dashboard")
    end
  end
end
