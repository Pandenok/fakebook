require 'rails_helper'

RSpec.describe "Posts", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    Capybara.page.current_window.resize_to(1440, 900)
    
    @user = create(:user)
    @friend = create(:user)
    @user.friends << @friend
    @friend_post = @friend.posts.create(body: "Jean shorts trust fund fanny pack poutine. Lumbersexual cred lomo. Poutine diy typewriter.")
    @text = "Five dollar toast echo chambray vegan kitsch mumblecore blog semiotics."
    @edited_text = "Brooklyn master loko. Marfa viral sartorial art party quinoa cred single origin coffee."
    login_as(@user, scope: :user)
  end

  scenario 'User can create, edit and delete a post' do
    visit new_post_path
    fill_in 'post_body', with: @text
    click_on('Post')

    expect(page).to have_content(@text)

    post = find('p', text: @text)
    post_card_header = post.sibling('#post_header')
    dropdown_button = post_card_header.find('.dropdown.inline-block.relative')
    dropdown_button.hover
    click_on('Edit post')
    fill_in 'post_body', with: @edited_text
    click_on('Save')

    expect(page).to have_content(@edited_text)

    edited_post = find('p', text: @edited_text)
    post_card_header = edited_post.sibling('#post_header')
    dropdown_button = post_card_header.find('.dropdown.inline-block.relative')
    dropdown_button.hover
    accept_alert { click_on('Delete post') }

    expect(page).to_not have_content(@edited_text)
  end

  scenario 'User can create a post with only images' do
    visit new_post_path
    attach_file('post[images][]', 'spec/images/smile.png', visible: false)
    click_on('Post')
    
    expect(page).to have_css("img[src*='smile.png']")
  end

  scenario 'User can not create an empty post' do
    visit new_post_path
    fill_in 'post_body', with: ''
    click_on('Post')
    expect(page).to have_content("can't be blank")
  end

  scenario 'User can not edit/delete a friend\'s post' do
    visit root_path
    friend_post = find('p', text: @friend_post.body)
    friend_post_card_header = friend_post.sibling('#post_header')

    expect(friend_post_card_header).to_not have_css('.dropdown.inline-block.relative')
  end
end
