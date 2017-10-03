# frozen_string_literal: true
module Hyrax
  class CollectionPresenter
    include ModelProxy
    include PresentsAttributes
    include ActionView::Helpers::NumberHelper
    attr_accessor :solr_document, :current_ability, :request

    # @param [SolrDocument] solr_document
    # @param [Ability] current_ability
    # @param [ActionDispatch::Request] request the http request context
    def initialize(solr_document, current_ability, request = nil)
      @solr_document = solr_document
      @current_ability = current_ability
      @request = request
    end

    # CurationConcern methods
    delegate :stringify_keys, :human_readable_type, :collection?, :representative_id,
             :to_s, to: :solr_document

    # Metadata Methods
    delegate :title, :description, :creator, :contributor, :subject, :publisher, :keyword, :language,
             :embargo_release_date, :lease_expiration_date, :rights, :date_created,
             :thumbnail_id, :resource_type, :based_near, :related_url, :identifier, to: :solr_document

    # Terms is the list of fields displayed by
    # app/views/collections/_show_descriptions.html.erb
    def self.terms
      [:total_items, :size, :resource_type, :creator, :contributor, :submitter, :keyword,
       :rights, :publisher, :date_created, :subject, :language, :identifier,
       :based_near, :related_url]
    end

    def terms_with_values
      self.class.terms.select { |t| self[t].present? }
    end

    def [](key)
      case key
      when :size
        size
      when :submitter
        submitter
      when :total_items
        total_items
      else
        solr_document.send key
      end
    end

    def submitter
      @solr_document.fetch('depositor_ssim', [])
    end

    def size
      number_to_human_size(@solr_document['bytes_lts'])
    end

    def total_items
      ActiveFedora::Base.where("member_of_collection_ids_ssim:#{id}").count
    end

    def display_feature_link?
      user_can_feature_collections? && solr_document.public? && FeaturedCollection.can_create_another? && !featured? && !CollectionAvatar.find_by(collection_id: id).nil?
    end

    def display_unfeature_link?
      user_can_feature_collections? && solr_document.public? && featured?
    end

    private

      def featured?
        if @featured.nil?
          @featured = FeaturedCollection.where(collection_id: solr_document.id).exists?
        end
        @featured
      end

      def user_can_feature_collections?
        current_ability.can?(:create, FeaturedCollection)
      end
  end
end
