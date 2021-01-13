require "rails_helper"

RSpec.describe User, type: :model do
  context 'enum' do 
    it { should define_enum_for(:gender)
          .with_values(
            male: "Male",
            female: "Female",
            custom: "Custom"
          ) 
          .backed_by_column_of_type(:string)
    }
  end
  
  context 'associations' do
    it { should have_many(:friend_requests).class_name('FriendRequest') }
    it { should have_many(:accepted_friend_requests).class_name('FriendRequest') }
    it { should have_many(:friends).through(:accepted_friend_requests) }
    it { should have_many(:posts) }
    it { should have_many(:likes) }
    it { should have_many(:comments) }
    it { should have_many(:notifications) }
    it { should have_one_attached(:avatar) }
    it { should have_one_attached(:cover_photo) }
  end

  context 'validations' do
    it { should validate_presence_of(:firstname) }
    it { should validate_presence_of(:lastname) }
  end

  context "#fullname" do
    it 'returns the concatenated first and last name' do
      user = build(:user, firstname: 'Fred', lastname: 'Flintstone')

      expect(user.fullname).to eq 'Fred Flintstone'
    end
  end

  context "#mutual_friends_with(user)" do
    before(:all) do
      @user_a = create(:user)
      @user_b = create(:user)
      @mutual_friend = create(:user)
      @user_a.friends << @mutual_friend
      @user_b.friends << @mutual_friend
    end

    it 'returns mutual friends between users' do
      result = @user_a.mutual_friends_with(@user_b)
      expect(result).to eq [@mutual_friend]
    end
  end
end