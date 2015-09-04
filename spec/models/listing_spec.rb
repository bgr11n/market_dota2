require 'rails_helper'

describe Listing do
  it 'has valid factory' do
    expect(FactoryGirl.create(:listing)).to be_valid
  end

  let(:listing) { build(:listing) }

  describe 'validations' do
    it { expect(listing).to validate_presence_of(:item) }
    it { expect(listing).to validate_presence_of(:user) }
    it { expect(listing).to validate_numericality_of(:price).is_greater_than(0) }
    it { expect(listing).to validate_numericality_of(:buy_price).is_greater_than(0) }
    it { expect(listing).to validate_numericality_of(:buy_price).is_greater_than(listing.price) }
    it { expect(listing).to validate_inclusion_of(:status).in_array([0, 100, 200, 300]) }

    it 'user cant buy own item' do
      listing = FactoryGirl.create(:listing)
      listing.bought_by_id = listing.user.id
      expect(listing).to_not be_valid
    end
  end

  describe 'callbacks' do
    it { expect(listing).to callback(:update_item).after(:save) }
  end

  describe 'scopes' do
    it '#active returns listings with status 100' do
      active_listing = create(:listing, status: 100)
      expect(Listing.active).to include(active_listing)
    end

    it '#by returns listings by selected user' do
      expected_listing = create(:listing)
      user = expected_listing.user
      expect(Listing.by(user)).to include(expected_listing)
    end
  end

  describe 'public instance methods' do
    context 'responds to methods' do
      it { expect(listing).to respond_to(:as_json) }
      it { expect(listing).to respond_to(:sell_to) }
    end

    context 'executes methods correctly' do
      context '#as_json' do

        it 'return valid json representation of obj' do
          json = {
            id: listing.id.to_s,
            status: listing.status,
            user_id: listing.user_id,
            price: listing.price,
            buy_price: listing.buy_price,
            item_id: listing.item_id.to_s,
            bought_by_id: listing.bought_by_id
          }
          expect(listing.as_json).to eq(json)
        end
      end

      context '#sell_to' do
        it 'assign bought_by to user' do
          user = create(:user)
          expect(listing.sell_to(user)).to eq({ success: true })
          expect(listing.sell_to(listing.user)).to eq({ success: false, errors: ["Вы не можете купить свою вещь"] })
        end
      end
    end
  end
end
