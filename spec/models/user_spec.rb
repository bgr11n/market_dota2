require 'rails_helper'

describe User do
  it 'has valid factory' do
    expect(create(:user)).to be_valid
  end

  let(:user) { build(:user) }

  describe 'validations' do
    it { expect(user).to validate_numericality_of(:balance).is_greater_than_or_equal_to(0).with_message('^Не достаточно средств') }
  end
end
