require 'rails_helper'

describe ItemsController do
  describe 'GET #index' do
    before { get :index }
    it { is_expected.to respond_with :ok }
    it { is_expected.to render_with_layout :application }
    it { is_expected.to render_template :index }
  end

  describe 'POST #create' do
    context 'when user is logged in' do
      before { session[:uid] = create(:user).uid }
      context 'with valid params' do
        before do
          request.env["HTTP_REFERER"] = 'back'
          listing = create(:listing)
          item = listing.item.attributes
          valid_attributes = item.merge(listing.attributes.except('item_id'))
          post :create, json_item: valid_attributes.to_json
        end
        it { expect(response).to redirect_to 'back' }
      end

      context 'with invalid params' do
        before do
          listing = create(:listing)
          item = listing.item.attributes
          listing.buy_price = -1
          invalid_attributes = item.merge(listing.attributes.except('item_id'))
          post :create, json_item: invalid_attributes.to_json
        end
        it { expect(response).to redirect_to '/inventory' }
        it { expect(flash[:error]).to be_present }
      end
    end

    context 'when user is not logged in' do
      before { post :create }
      it { expect(response).to redirect_to :root }
      it { expect(flash[:error]).to be_present }
    end
  end

  describe 'GET #item' do
    before do
      item = Item.first
      get :show, market_hash_name: item.market_hash_name
    end
    it { is_expected.to respond_with :ok }
    it { is_expected.to render_with_layout :application }
    it { is_expected.to render_template :show }
  end
end
