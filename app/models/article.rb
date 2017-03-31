# frozen_string_literal: true
# Generated via
#  `rails generate curation_concerns:work Article`
class Article < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::CurationConcerns::BasicMetadata
  include Sufia::WorkBehavior
  include RemotelyIdentifiedByDoi::Attributes

  self.human_readable_type = 'Article'
  self.human_readable_short_description = 'Published or unpublished articles'
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  property :alternate_title, predicate: ::RDF::URI.new('http://purl.org/dc/terms/title#alternative') do |index|
    index.as :stored_searchable
  end

  property :geo_subject, predicate: ::RDF::URI.new('http://purl.org/dc/terms/coverage#spatial') do |index|
    index.as :stored_searchable, :facetable
  end

  property :journal_title, predicate: ::RDF::Vocab::DC.source do |index|
    index.as :stored_searchable
    index.type :text
  end

  property :issn, predicate: ::RDF::URI.new('http://purl.org/dc/terms/identifier#issn') do |index|
    index.as :stored_searchable
  end

  property :time_period, predicate: ::RDF::URI.new('http://purl.org/dc/terms/coverage#temporal') do |index|
    index.as :stored_searchable, :facetable
  end

  property :required_software, predicate: ::RDF::Vocab::DC.requires, multiple: false do |index|
    index.as :stored_searchable
  end

  property :note, predicate: ::RDF::URI.new('http://purl.org/dc/terms/description#note'), multiple: false do |index|
    index.as :stored_searchable
  end

  property :bibliographic_citation, predicate: ::RDF::Vocab::DC.bibliographicCitation, multiple: false do |index|
    index.as :bibliographic_citation
  end
end
