require 'rails_helper'

describe Item do
  it 'has valid factory' do
    expect(FactoryGirl.create(:item)).to be_valid
  end

  describe '.fetch_min_price' do
    it 'update object with min price of listings'
  end
end
