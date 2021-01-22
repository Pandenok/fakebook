require 'rails_helper'

RSpec.describe "FriendRequests", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    Capybara.page.current_window.resize_to(1920, 1080)

    @user = create(:user)
    @friendly_user = create(:user)
    @misanthropic_user = create(:user)
  end

  scenario 'User can send a friend request' do
    login_as(@user, scope: :user)
    visit users_path
    friendly_user_card = find('h1', text: 'People You May Know').sibling('div', text: @friendly_user.fullname)
    add_button = friendly_user_card.find('a', text: 'Add Friend')
    add_button.click

    expect(page).to have_content ("Friend request to #{@friendly_user.firstname} sent!")
    expect(page).to_not have_content(@friendly_user.fullname)
  end

  scenario 'User can accept friend request' do
    @user.friend_requests.create(friend_id: @friendly_user.id, status: :pending)
    login_as(@friendly_user, scope: :user)
    visit users_path
    user_card = find('h2', text: 'Friend Request').sibling('div', text: @user.fullname)
    confirm_button = user_card.find('a', text: 'Confirm')
    confirm_button.click

    expect(page).to have_content ("#{@user.firstname}'s friend request accepted!")
    expect(page).to_not have_content(@user.fullname)
  end

  scenario 'User can reject friend request' do
    @user.friend_requests.create(friend_id: @misanthropic_user.id, status: :pending)
    login_as(@misanthropic_user, scope: :user)
    visit users_path
    user_card = find('h2', text: 'Friend Request').sibling('div', text: @user.fullname)
    delete_button = user_card.find('a', text: 'Delete')
    delete_button.click

    expect(page).to have_content ("#{@user.firstname}'s friend request rejected!")
    expect(find('h1', text: 'People You May Know')).to_not have_sibling('div', text: @user.fullname)
  end
end
