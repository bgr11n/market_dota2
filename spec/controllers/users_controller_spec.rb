require 'rails_helper'

describe UsersController do
  describe 'GET #account' do
    context 'when user is logged in' do
      before do
        session[:uid] = create(:user).uid
        get :account
      end
      it { is_expected.to render_with_layout :application }
      it { is_expected.to render_template :account }
      it { expect(response.status).to eq 200 }
    end

    context 'when user is not logged in' do
      before { get :account }
      it { expect(response).to redirect_to :root }
      it { expect(flash[:error]).to be_present }
    end
  end

  describe 'POST #logout' do
    context 'when user is logged in' do
      before do
        session[:uid] = create(:user).uid
        post :logout
      end
      it { is_expected.to redirect_to :root }
      it { expect(response.status).to eq 302 }
    end

    context 'when user is not logged in' do
      before { get :account }
      it { expect(response).to redirect_to :root }
      it { expect(flash[:error]).to be_present }
    end
  end
end
