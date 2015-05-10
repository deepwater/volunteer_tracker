require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'datatables loads successfully' do
  background do
  	@volunteer = FactoryGirl.create(:volunteer)
  	@super_admin = FactoryGirl.create(:super_admin)
  	login_as @super_admin
  end

  scenario 'admin users page', js: true do
  	visit admin_path
    expect(page).to have_content @volunteer.email
  end
end