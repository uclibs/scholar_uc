# frozen_string_literal: true
# Generated via
#  `rails generate curation_concerns:work Dataset`
module CurationConcerns
  class DatasetForm < Sufia::Forms::WorkForm
    self.model_class = ::Dataset
    self.terms += [:resource_type, :alternate_title, :time_period, :required_software, :note]
    self.terms -= [:keyword, :source, :contributor]
    self.required_fields = [:title, :creator, :description, :required_software, :rights]

    def secondary_terms
      [:date_created, :alternate_title, :subject, :geo_subject,
       :time_period, :language, :bibliographic_citation,
       :note]
    end

    def self.multiple?(field)
      if [:title, :description, :rights, :date_created].include? field.to_sym
        false
      else
        super
      end
    end

    def self.model_attributes(_)
      attrs = super
      attrs[:title] = Array(attrs[:title]) if attrs[:title]
      attrs[:description] = Array(attrs[:description]) if attrs[:description]
      attrs[:date_created] = Array(attrs[:date_created]) if attrs[:date_created]
      attrs
    end

    def title
      super.first || ""
    end

    def description
      super.first || ""
    end

    def date_created
      super.first || ""
    end
  end
end
