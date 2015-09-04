require 'rails_helper'

describe Item do
  it 'has valid factory' do
    expect(create(:item)).to be_valid
  end

  let(:item) { build(:item) }

  describe 'validations' do
    it { expect(item).to validate_numericality_of(:min_price).is_greater_than_or_equal_to(0) }
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { expect(item).to respond_to(:fetch_min_buy_price) }
    end

    context 'executes correctly' do
      context '#fetch_min_buy_price' do
        it 'fetches min price of listings for current item' do
          listing = create(:listing)
          expected_min_price = listing.buy_price
          item = listing.item
          item.fetch_min_buy_price
          expect(item.min_price).to eq(expected_min_price)
        end
      end
    end
  end
end
