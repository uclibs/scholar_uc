# frozen_string_literal: true
class DocumentPresenter < Sufia::WorkShowPresenter
  delegate :alternate_title, :genre, :time_period, :required_software, :note, :doi, to: :solr_document
end