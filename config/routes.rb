Rails.application.routes.draw do

  resources :bookmarks, only: [:create, :destroy]
#  get "/inform" => "inform#gamen_sentaku"
#  get "inform/hatsugen_inf"
#  get "inform/hatsugen_inf/:ht11" => "inform#toukou"
#  get "inform/hatsugen_inf/:re_id" => "inform#toukou"
#  get "inform/toukou" => "inform"
#  get "/b_inform/bosyuu_inf"
#  get "b_inform/:ht22" => "b_inform#toukou"
#  get "b_inform/:re_id" => "b_inform#toukou"
#  get "b_inform/toukou" => "b_inform"

  devise_for :accounts, :controllers =>{
      :registrations => 'accounts/registrations'
  }

  devise_scope :account do
    post '/accounts/sign_up/confirm', to: 'accounts/registrations#confirm'
  end

  resources :recruitments, only: [ :edit, :update, :destroy ]
  post '/recruitments/create/:id', to: 'recruitments#create', as: :recruitments_create
  post '/recruitments/:id', to: 'recruitments#update', constraints: {id: /[0-9]+/ }
  # 返信追加読み込み
  post '/recruitments/edit/add/:id/:offset_time', to: 'recruitments#add_result', as: :results_add, constraints: { id:/[0-9]+/ }
  post '/recruitments/select/:id/:comment_id', to: 'recruitments#select', as: :select_result, constraints: { id:/[0-9]+/, comment_id:/[0-9]+/ }
  post '/recruitments/selected/:id/:comment_id', to: 'recruitments#selected', as: :selected_result, constraints: { id:/[0-9]+/, comment_id:/[0-9]+/ }

# 返信生成削除
  resources :comments, only: [ :create, :destroy ]
  get '/comments/index/:recruitment_id', to: 'comments#index', as: :comments_index, constraints: { recruitment_id: /[0-9]+/ }
  # 返信追加読み込み
  post '/comments/index/add/:recruitment_id/:offset_time', to: 'comments#add_index', as: :comments_add, constraints: { recruitment_id:/[0-9]+/ }
  
  resources :chat_comments, only: [:destroy]
  get '/chat_comments/:recruitment_id', to: 'chat_comments#index', as: :chat_comments_index
  post '/chat_comments/create/:chat_id', to: 'chat_comments#create', as: :chat_comments_create

  resources :entry_chats, only: [:create, :destroy]
  # チャット有り結果選択
  get '/entry_chats/new/:recruitment_id', to: 'entry_chats#new', as: :new_entry_chats, constraints: { recruitment_id: /[0-9]+/ }
  # 返信追加読み込み
  post '/entry_chats/new/add/:recruitment_id/:offset_time', to: 'entry_chats#add_result', as: :results_chat_add, constraints: { recruitment_id:/[0-9]+/ }

  resources :pictures

  root 'mains#index'

  get 'home/:acc_id', to: 'home#show', as: :account_show
  get '/home/button/:acc_id/:id', to: 'home#button', as: 'home_button'
  get 'home/delete/:acc_id', to: 'home#delete', as: :account_delete
  get '/home/button_view/:acc_id/:id', to: 'home#button_view', as: :home_button_view

  post '/' => 'tags#update'#タグ検索フォーム

  get '/mains/button_view/:id', to: 'mains#button_view', as: :mains_button_view
  get '/mains/button_form/:id', to: 'mains#button_form', as: :mains_button_form
  get '/mains/index/add/:size', to: 'mains#add_index', as: :mains_add, constraints: { size: /[0-9]+/ }

  get '/members/:chat_id', to: 'members#index', as: 'members'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/univtag/list', to: 'univtag#list' #タグ取得用

  get '/verify/recruit', to: 'verify#recruit' #検証用
  get '/verify/recruit2', to: 'verify#recruit2'
end
