require 'rails_helper'

describe 'datatables loads successfully' do
  before do
    organisation = FactoryGirl.create(:organisation)
    @super_admin = FactoryGirl.create(:super_admin, organisation: organisation)
    @volunteer   = FactoryGirl.create(:volunteer, organisation: organisation)
    @subaccount  = FactoryGirl.create(:super_admin, organisation: organisation, master: @volunteer)
  end

  it 'admin users page', js: true do
    sign_in @super_admin
    visit admin_root_path
    expect(page).to have_content @volunteer.email
  end

  it 'subaccounts page', js: true do
    sign_in @volunteer
    visit user_subaccounts_path(@volunteer)
    expect(page).to have_content @subaccount.username
  end
end
