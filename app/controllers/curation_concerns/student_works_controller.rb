# frozen_string_literal: true
# Generated via
#  `rails generate curation_concerns:work StudentWork`

module CurationConcerns
  class StudentWorksController < ApplicationController
    include CurationConcerns::CurationConcernController
    # Adds Sufia behaviors to the controller.
    include Sufia::WorksControllerBehavior
    include Scholar::WorksControllerBehavior
    include Sufia::IIIFManifest

    self.curation_concern_type = StudentWork
  end
end
