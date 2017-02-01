# frozen_string_literal: true
require 'rails_helper'

RSpec.describe '/concern/generic_works routing' do
  it "routes to manifest" do
    expect(get: '/concern/generic_works/1234/manifest')
      .to route_to(controller: 'curation_concerns/generic_works', action: 'manifest', id: '1234')
  end
end
