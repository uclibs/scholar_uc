# frozen_string_literal: true
class CollectionsController < ApplicationController
  include Hyrax::CollectionsControllerBehavior
  include Sufia::CollectionsControllerBehavior

  def new
    super
    collection.visibility = "open"
  end
end