require "rails_helper"

RSpec.describe Post, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:likes) }
    it { should have_many(:comments) }
    it { should have_many_attached(:images) }
  end

  context 'validations' do
    context 'if there are no images attached' do
      before { allow(subject.images).to receive(:attached?).and_return(false) }
      it { should validate_presence_of(:body) }
    end
    context 'if there are images attached' do
      before { allow(subject.images).to receive(:attached?).and_return(true) }
      it { should_not validate_presence_of(:body) }
    end
  end
end