require 'rails_helper'

describe Listing do
  it 'has valid factory' do
    expect(FactoryGirl.create(:listing)).to be_valid
  end
end
