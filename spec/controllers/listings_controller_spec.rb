require 'rails_helper'

describe ListingsController do
  describe 'GET #show' do
    context 'when user is logged in' do
      before do
        session[:uid] = create(:user).uid
        listing = Listing.first
        @expected = { listing: listing.as_json, item: listing.item }
        get :show, id: listing.id
      end
      it { expect(response.body).to eq(@expected.to_json) }
    end

    context 'when user is not logged in' do
      before { get :show, id: Listing.first.id }
      it { expect(response).to redirect_to :root }
      it { expect(flash[:error]).to be_present }
    end
  end

  describe 'PUT #update' do
    context 'when user is logged in' do
      before do
        request.env["HTTP_REFERER"] = 'back'
        session[:uid] = create(:user).uid
        @listing = Listing.first
      end

      context 'with valid params' do
        before do
          @listing.price = 1
          @listing.buy_price = 2
          put :update, { id: @listing.id, listing: @listing.as_json }
        end
        it { expect(response).to redirect_to 'back' }
        it { expect(flash[:notice]).to be_present }
      end

      context 'with invalid params' do
        before do
          @listing.price = 1
          @listing.buy_price = 1
          put :update, { id: @listing.id, listing: @listing.as_json }
        end
        it { expect(response).to redirect_to 'back' }
        it { expect(flash[:error]).to be_present }
      end
    end

    context 'when user is not logged in' do
      before { put :update, id: Listing.first.id }
      it { expect(response).to redirect_to :root }
      it { expect(flash[:error]).to be_present }
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is logged in' do
      before do
        session[:uid] = create(:user).uid
        @listing = Listing.first
      end

      context 'with valid params' do
        before { delete :destroy, id: @listing.id }
        it { expect(response).to redirect_to :root }
        it { expect(flash[:notice]).to be_present }
      end
    end

    context 'when user is not logged in' do
      before { delete :destroy, id: Listing.first.id }
      it { expect(response).to redirect_to :root }
      it { expect(flash[:error]).to be_present }
    end
  end

  describe 'POST #buy' do
    context 'when user is logged in' do
      before do
        request.env["HTTP_REFERER"] = 'back'
        @user = create(:user)
        @listing = Listing.first
        session[:uid] = @user.uid
      end

      context 'with valid params' do
        before do
          @user.update balance: @listing.buy_price
          post :buy, id: @listing.id
        end
        it { expect(response).to redirect_to 'back' }
        it { expect(flash[:notice]).to be_present }
      end

      context 'when user doesnt have money' do
        before do
          @user.update balance: (@listing.buy_price - 1)
          post :buy, id: @listing.id
        end
        it { expect(response).to redirect_to 'back' }
        it { expect(flash[:error]).to be_present }
      end

      context 'when user try to buy own item' do
        before do
          @listing.update user_id: @user.id
          post :buy, id: @listing.id
        end
        it { expect(response).to redirect_to 'back' }
        it { expect(flash[:error]).to be_present }
      end

      context 'when user try to buy listing with status SOLD' do
        before { @listing.update status: Listing::SOLD }
        it { expect { post :buy, id: @listing.id }.to raise_error(ActionController::RoutingError) }
      end
    end

    context 'when user is not logged in' do
      before { post :buy, id: Listing.first.id }
      it { expect(response).to redirect_to :root }
      it { expect(flash[:error]).to be_present }
    end
  end
end
