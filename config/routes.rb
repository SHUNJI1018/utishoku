Rails.application.routes.draw do
  # 管理者側(sign_in, _outのみ)
  devise_for :admins, skip: :all
  devise_scope :admin do
    get 'admin/sign_in' => 'admin/sessions#new', as: 'new_admin_session'
    post 'admin/sign_in' => 'admin/sessions#create', as: 'admin_session'
    delete 'admin/sign_out' => 'admin/sessions#destroy', as: 'destroy_admin_session'
  end

  # ユーザー側(sign_up, _in, _out)
  devise_for :customers, skip: :all
  devise_scope :customer do
    get 'customers/sign_in' => 'public/sessions#new', as: 'new_customer_session'
    post 'customers/sign_in' => 'public/sessions#create', as: 'customer_session'
    delete 'customers/sign_out' => 'public/sessions#destroy', as: 'destroy_customer_session'
    get 'customers/sign_up' => 'public/registrations#new', as: 'new_customer_registration'
    post 'customers' => 'public/registrations#create', as: 'customer_registration'
  end

  # 管理者側のルーティング
  namespace :admin do
    # ジャンルの追加・編集
    resources :genres, only: %i[index create edit update]
    # ユーザー管理に関するルーティング
    resources :customers, only: %i[index edit update]
  end

  # 会員情報に関するルーティング
  scope module: :public do
    root to: 'homes#top'
    get '/index' => 'homes#index'

    # 通知機能に関するルーティング
    resources :notifications, only: :index
    delete :notifications, to: 'notifications#destroy_all'

    # 投稿に関するルーティング
    resources :diys, only: %i[new create index show update destroy] do
      resources :diy_comments, only: %i[create destroy]
      # いいね機能に関するルーティング
      resource :favorites, only: %i[create destroy]
      # 検索機能に関するルーティング
      collection do
        get 'search'
      end
    end

    resources :customers, only: %i[show edit update] do
      # フォロー・フォロワー機能に関するルーティング
      resource :relationships, only: %i[show create destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'

      # ユーザー凍結機能に関するルーティング(現状管理者のみ可能)
      collection do
        get 'hide' => 'customers#hide'
        post 'out'
        patch 'out'
      end
    end
  end
end
