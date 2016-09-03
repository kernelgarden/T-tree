Rails.application.routes.draw do
  devise_for :users, :controllers =>{:omniauth_callbacks =>"users/omniauth_callbacks" }
  root 'main#home'
  get 'users/new'
  get 'users/profile'
  get 'main/login'
  get 'main/team/:id', to: 'main#team'

  resources :users

  get '/main/work/:id', to: 'main#work'

  get '/show/pages', to: 'main#pages'

  #json
  get '/api/users', to: 'apis#users'          #모든 user들의 정보
  get '/api/user_ids', to: 'apis#user_ids'       #모든 user들의 id들
  get '/api/user/:id', to: 'apis#user'         #해당 user의 정보
  get '/api/user/:id/works', to: 'apis#works'   #해당 user의 work들의 정보
  get '/api/user/:id/work_ids', to: 'apis#work_ids'   #해당 user의 work id들
  get '/api/team/:id', to: 'apis#team'         #해당 team의 정보
  get '/api/team/:id/works', to: 'apis#teamworks'   #해당 team의 work들의 정보
  get '/api/team/:id/work_ids', to: 'apis#teamwork_ids'   #해당 team의 work id들
  get '/api/team/:id/member_ids', to: 'apis#member_ids'   #해당 team의 user id들
  get '/api/work/:id', to: 'apis#work'         #해당 work의 정보
  get '/api/work/:id/branches', to: 'apis#branches' #해당 work의 branch들의 정보
  get '/api/work/:id/branche_ids', to: 'apis#branche_ids' #해당 work의 branch id들
  get '/api/work/:id/tree', to: 'apis#tree'      #해당 work의 tree
  get '/api/branch/:id', to: 'apis#branch'      #해당 branch의 정보
  get '/api/branch/:id/childs', to: 'apis#branchChilds'      #해당 branch의 정보
  get '/api/branch/:id/pages', to: 'apis#pages' #해당 branch의 page들의 정보
  get '/api/branch/:id/page_ids', to: 'apis#page_ids' #해당 branch의 page id들
  get '/api/page/:id', to: 'apis#page'         #해당 page의 정보

  get '/api/user/:id/unclassifiedpages', to: 'apis#unclassifiedpages' #해당 branch의 page들의 정보
  get '/api/unclassifiedpage/:id', to: 'apis#unclassifiedpage'         #해당 page의 정보


  post '/api/post/work', to: 'apis#getWork'         #해당 work의 정보
  get '/api/post/work', to: 'apis#getWork1'         #해당 work의 정보
  post '/api/post/team', to:'apis#getTeam'
  post '/api/page/new', to: 'apis#getPages'

  get '/search', to:'search#getResult'
  # For details on the DSL available within this file, see http://guides.ruonrails.org/routing.html
end