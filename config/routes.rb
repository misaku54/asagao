Rails.application.routes.draw do
  root "top#index"
  # as:は指定した名前のヘルパーを作成する　about_path,about_url
  get "about" => "top#about", as:"about"
  get "bad_request" => "top#bad_request"
  get "forbidden" => "top#forbidden"
  get "internal_server_error" => "top#internal_server_error"

  1.upto(18) do |n|
    get "lesson/step#{n}(/:name)" => "lesson#step#{n}"
  end

  # resourcesメソッドでリソースベースのルーティング設定
  # serchアクションの追加によるルーティング
  resources :members do
    get "search" , on: :collection
    # 個人のブログ一覧のリソース設定
    resources :entries, only: [:index]
  end
  resource :session, only: [:create,:destroy]
  resource :account, only: [:show,:edit,:update]
  resource :password, only: [:show,:edit,:update]
  
  resources :articles
  # 通常のブログのルーティング設定
  resources :entries
end
