# frozen_string_literal: true
# Generated via
#  `rails generate curation_concerns:work StudentWork`
class StudentWork < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::CurationConcerns::BasicMetadata
  include Sufia::WorkBehavior
  self.human_readable_type = 'Student Work'
  self.human_readable_short_description = 'Deposit any kind of student work (excluding Theses and Dissertations).'
  include RemotelyIdentifiedByDoi::Attributes

  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  property :alternate_title, predicate: ::RDF::URI.new('http://purl.org/dc/terms/title#alternative') do |index|
    index.as :stored_searchable
  end

  property :geo_subject, predicate: ::RDF::URI.new('http://purl.org/dc/terms/coverage#spatial') do |index|
    index.as :stored_searchable, :facetable
  end

  property :advisor, predicate: ::RDF::URI.new('http://purl.org/dc/terms/contributor#advisor') do |index|
    index.as :stored_searchable
  end

  property :degree, predicate: ::RDF::URI.new('http://purl.org/dc/terms/subject#degree') do |index|
    index.as :stored_searchable
  end

  property :genre, predicate: ::RDF::URI.new('http://purl.org/dc/terms/type#genre') do |index|
    index.as :stored_searchable, :facetable
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

  property :college, predicate: ::RDF::URI.new('http://purl.org/dc/terms/subject#college'), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :department, predicate: ::RDF::URI.new('http://purl.org/dc/terms/subject#department'), multiple: false do |index|
    index.as :stored_searchable, :facetable

  def self.to_s_u
    'student_work'
  end
end
