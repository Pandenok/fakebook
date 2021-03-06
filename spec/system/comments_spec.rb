require 'rails_helper'

RSpec.describe "Comments", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    Capybara.page.current_window.resize_to(1440, 900)

    @user = create(:user)
    @another_user = create(:user)
    @post = @user.posts.create(body: "Jean shorts trust fund fanny pack poutine. Lumbersexual cred lomo. Poutine diy typewriter.")
    @another_user_comment = @post.comments.create(body: "Tumblr muggle magic viral chambray austin leggings.", user: @another_user)
    @comment = "Iphone microdosing normcore shabby chic."
    @new_comment = "Fanny pack actually quinoa."
    login_as(@user, scope: :user)
  end

  scenario 'User can create, edit and delete a comment' do
    visit root_path
    find('#comment_body').click.send_keys @comment, :return
    
    expect(page).to have_content(@comment)

    dropdown_button = find("#comment_#{@user.comments.last.id}").sibling('div')
    dropdown_button.hover
    click_on('Edit')
    form = find("#edit_comment_#{@user.comments.last.id} input")
    form.click
    form.value.length.times { form.send_keys [:backspace] }
    form.send_keys @new_comment, :return
    
    expect(page).to have_css("#comment_#{@user.comments.last.id}", text: @new_comment)

    dropdown_button = find("#comment_#{@user.comments.last.id}").sibling('div')
    dropdown_button.hover
    accept_alert { click_on('Delete') }
    
    expect(page).to_not have_content(@new_comment)
  end

  scenario 'User can not edit/delete a comment of another user' do
    visit root_path
    another_user_comment = find("#comment_#{@another_user_comment.id}")
    
    expect(another_user_comment).to_not have_sibling('div', right_of: another_user_comment)
  end
end
