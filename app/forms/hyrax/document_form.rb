# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work Document`
module Hyrax
  class DocumentForm < Hyrax::Forms::WorkForm
    self.model_class = ::Document

    ## Adding custom descriptive metadata terms
    self.terms += %i(alternate_title genre time_period required_software note
                     geo_subject alt_description alt_date_created)

    ## Adding terms needed for the special DOI form tab
    self.terms += %i(doi doi_assignment_strategy existing_identifier)

    ## Adding terms college and department
    self.terms += %i(college department)

    ## Removing terms that we don't use
    self.terms -= %i(keyword source contributor)

    ## Setting custom required fields
    self.required_fields = %i(title creator college department alt_description rights)

    ## Adding above the fold on the form without making this required
    def primary_terms
      required_fields + [:publisher]
    end

    ## Overriding secondary terms to establish custom field order
    def secondary_terms
      %i(alt_date_created alternate_title genre
         subject geo_subject time_period language
         required_software note related_url)
    end

    ## Gymnastics to allow repeatble fields to behave as non-repeatable

    def self.model_attributes(_)
      attrs = super
      attrs[:title] = Array(attrs[:title]) if attrs[:title]
      attrs
    end

    def title
      super.first || ""
    end
  end
end
