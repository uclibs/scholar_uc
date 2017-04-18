# frozen_string_literal: true
module Sufia
  module Forms
    class BatchUploadForm < Sufia::Forms::WorkForm
      self.model_class = BatchUploadItem
      include HydraEditor::Form::Permissions

      attr_accessor :payload_concern # a Class name: what is form creating a batch of?

      self.terms = %i(creator description right publisher date_created subject
                      language identifier based_near related_url representative_id
                      thumbnail_id files visibility_during_embargo embargo_release_date
                      visibility_after_embargo visibility_during_lease
                      lease_expiration_date visibility_after_lease visibility
                      ordered_member_ids in_works_ids collection_ids admin_set_id
                      alternate_title journal_title issn time_period required_software
                      note geo_subject doi doi_assignment_strategy existing_identifier
                      college department genre degree advisor)

      def required_fields
        case @payload_concern
        when "Dataset"
          %i(title creator college department description required_software rights)
        when "Etd"
          %i(title creator college department description advisor rights)
        when "StudentWork"
          %i(title creator college department description advisor rights)
        else
          %i(title creator college department description rights)
        end
      end

      def primary_terms
        case @payload_concern
        when "Dataset"
          %i(creator college department description required_software rights publisher)
        when "StudentWork"
          %i(creator college department description advisor rights degree publisher)
        when "Etd"
          %i(creator college department description advisor rights committee_member degree date_created publisher)
        else
          %i(creator college department description rights publisher)
        end
      end

      def secondary_terms
        case @payload_concern
        when "Article"
          %i(date_created alternate_title journal_title issn subject geo_subject time_period language required_software note)
        when "Dataset"
          %i(date_created alternate_title subject geo_subject time_period language note)
        when "Document"
          %i(date_created alternate_title subject geo_subject time_period language required_software note)
        when "Image"
          %i(date_created alternate_title genre subject geo_subject time_period language required_software note)
        when "Video"
          %i(date_created alternate_title subject geo_subject time_period language required_software note)
        when "StudentWork"
          %i(date_created alternate_title genre subject geo_subject time_period language required_software note)
        when "Etd"
          %i(alternate_title genre subject geo_subject time_period language required_software note)
        when "GenericWork"
          %i(date_created alternate_title subject geo_subject time_period language required_software note)
        else
          %i(date_created alternate_title subject geo_subject time_period language required_software note)
        end
      end

      # The WorkForm delegates `#depositor` to `:model`, but `:model` in the
      # BatchUpload context is a blank work with a `nil` depositor
      # value. This causes the "Sharing With" widget to display the Depositor as
      # "()". We should be able to reliably pull back the depositor of the new
      # batch of works by asking the form's Ability what its `current_user` is.
      def depositor
        current_ability.current_user
      end

      # Override of ActiveModel::Model name that allows us to use our custom name class
      def self.model_name
        @_model_name ||= begin
          namespace = parents.detect do |n|
            n.respond_to?(:use_relative_model_naming?) && n.use_relative_model_naming?
          end
          Name.new(model_class, namespace)
        end
      end

      def model_name
        self.class.model_name
      end

      # This is required for routing to the BatchUploadController
      def to_model
        self
      end

      # A model name that provides correct routes for the BatchUploadController
      # without changing the param key.
      #
      # Example:
      #   name = Name.new(GenericWork)
      #   name.param_key
      #   # => 'generic_work'
      #   name.route_key
      #   # => 'batch_uploads'
      #
      class Name < ActiveModel::Name
        def initialize(klass, namespace = nil, name = nil)
          super
          @route_key          = "batch_uploads"
          @singular_route_key = ActiveSupport::Inflector.singularize(@route_key)
          @route_key << "_index" if @plural == @singular
        end
      end
    end
  end
end
