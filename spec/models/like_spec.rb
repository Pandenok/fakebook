require "rails_helper"

RSpec.describe Like, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end

  context 'validations' do
    subject { FactoryBot.build(:like) }

    it { should validate_uniqueness_of(:user_id).scoped_to(:post_id) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:post_id) }
  end
end