require 'spec_helper'

describe 'shared/_brand_bar.html.erb' do

  before(:each) do
    view.stub(:current_user).and_return(current_user)
    render partial: 'shared/brand_bar.html.erb'
  end

  def have_login_section
    have_tag('.login', with: { href: new_user_session_path } )
  end

  def have_user_menu_section(&block)
    have_tag('a.user-display-name', &block)
  end

  context 'logged in' do
    let(:person) { double(pid: 'test:1234') }
    let(:name) { 'My Display Name' }
    let(:current_user) { User.new(name: name, person: person).tap {|u| u.stub(groups: ['registered'])} }
    it 'renders a link for the user menu' do
      expect(rendered).to_not have_login_section
      expect(rendered).to have_user_menu_section do
          with_tag 'a.user-display-name', text: /#{name}/
      end
    end
  end

  context 'not logged in' do
    let(:current_user) { nil }
    it 'renders a link to create a new user session' do
      expect(rendered).to_not have_user_menu_section
      expect(rendered).to have_login_section
    end
  end
end