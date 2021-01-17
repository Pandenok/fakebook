require 'rails_helper'

RSpec.describe "Likes", type: :system do
  before do
    driven_by(:rack_test)

    @user = create(:user)
    @post = @user.posts.create(body: Faker::Hipster.paragraph(sentence_count: 1))
    login_as(@user, scope: :user)
  end

  scenario 'User can like and unlike a post' do
    visit root_path
    click_on "Like"

    expect(page).to have_content('You liked the post')
    
    click_on "Like"
    
    expect(page).to have_content('You unliked the post')
  end
end
