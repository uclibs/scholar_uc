# frozen_string_literal: true
require Hyrax::Engine.root.join('app/controllers/concerns/hyrax/file_sets_controller_behavior.rb')
module Hyrax
  module FileSetsControllerBehavior
    def show
      super
      permalink_message = "Permanent link to this page"
      @permalinks_presenter = PermalinksPresenter.new(main_app.common_object_path, permalink_message)
    end
  end
end