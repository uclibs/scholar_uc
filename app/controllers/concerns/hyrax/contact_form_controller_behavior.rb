# frozen_string_literal: true
module Hyrax
  module ContactFormControllerBehavior
    extend ActiveSupport::Concern
    FAIL_NOTICE = "You must complete the Captcha to confirm the form."

    included do
      before_action :build_contact_form
    end

    def new; end

    def create
      # not spam and a valid form
      if @contact_form.valid? && passes_captcha_or_is_logged_in?
        Hyrax::ContactMailer.contact(@contact_form).deliver_now
        flash.now[:notice] = 'Thank you for your message!'
        @contact_form = ContactForm.new
      else
        flash.now[:error] = FAIL_NOTICE
      end
      render :new
    rescue RuntimeError => e
      logger.error("Contact form failed to send: #{e.inspect}")
      flash.now[:error] = 'Sorry, this message was not delivered.'
      render :new
    end

    def verify_google_recaptcha(_key, response)
      status = `curl "https://www.google.com/recaptcha/api/siteverify?secret=#{CAPTCHA_SERVER['secret_key']}&response=#{response}"`
      hash = JSON.parse(status)
      hash["success"] == true ? true : false
    end

    protected

      def build_contact_form
        @contact_form = Hyrax::ContactForm.new(contact_form_params)
      end

      def contact_form_params
        return {} unless params.key?(:contact_form)
        params.require(:contact_form).permit(:contact_method, :category, :name, :email, :subject, :message)
      end

      def passes_captcha_or_is_logged_in?
        return true if current_user.present?
        verify_google_recaptcha(CAPTCHA_SERVER['secret_key'], params["g-recaptcha-response"])
      end
  end
end
