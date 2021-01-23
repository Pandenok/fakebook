require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    Capybara.page.current_window.resize_to(1440, 900)

    @user = create(:user)
    @other_user = create(:user)
    @bio = Faker::Movie.unique.quote
    @relationship_status = Faker::Demographic.marital_status
    @workplace = Faker::Company.name
    @hometown = Faker::Address.city
    @hobbies = Faker::Superhero.power
    login_as(@user, scope: :user)
  end

  scenario 'User can upload avatar and cover photo' do
    visit user_path(@user)
    attach_file('user[avatar]', 'spec/images/smile.png', visible: false)
    attach_file('user[cover_photo]', 'spec/images/cover_photo.jpg', visible: false)

    expect(page).to have_css("img[src*='smile.png']", wait: 20)
    expect(page).to have_css("img[src*='cover_photo.jpg']", wait: 20)
  end

 scenario 'User can edit profile info' do
    visit user_path(@user)
    find('span', text: 'Edit Profile').click
    fill_in 'user_bio', with: @bio
    fill_in 'user_workplace', with: @workplace
    fill_in 'user_hometown', with: @hometown
    fill_in 'user_relationship_status', with: @relationship_status
    fill_in 'user_hobbies', with: @hobbies
    click_on('Edit Your About Info')

    expect(page).to have_content(@bio)
    expect(page).to have_content(@workplace)
    expect(page).to have_content(@hometown)
    expect(page).to have_content(@relationship_status)
    expect(page).to have_content(@hobbies)
  end

  scenario 'User can preview profiles of other users' do
    visit users_path
    other_user_card = find('h1', text: 'People You May Know')
      .sibling('div', text: @other_user.fullname)
      .find('a', text: @other_user.fullname)
    other_user_card.click
    other_user_profile = find('#profile-section').find('.mt-8.text-center.text-4xl.font-bold')

    expect(other_user_profile).to have_content(@other_user.fullname)
  end
end
