require 'spec_helper'

describe PageRequestsController do
  describe '#view_terms' do
    it 'renders a terms and conditions page' do
        get :view_terms
        response.status.should == 200
        expect(response).to render_template('terms')
    end
  end

  describe '#view_about' do
    it 'renders an about this application page' do
        get :view_about
        response.status.should == 200
        expect(response).to render_template('about')
    end
  end

  describe '#view_presentation' do
    it 'renders the presentation page' do
        get :view_presentation
        response.status.should == 200
        expect(response).to render_template('presentation')
    end
  end

  describe '#view_coll_pol' do
    it 'renders the collection policy page' do
        get :view_coll_pol
        response.status.should == 200
        expect(response).to render_template('coll_policy')
    end
  end

  describe '#view_pres_policy' do
    it 'renders the presentation policy page' do
        get :view_pres_pol
        response.status.should == 200
        expect(response).to render_template('pres_policy')
    end
  end

  describe '#view_FAQ' do
    it 'renders the FAQ page' do
        get :view_faq
        response.status.should == 200
        expect(response).to render_template('faq')
    end
  end
end
