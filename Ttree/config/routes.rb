Rails.application.routes.draw do
  devise_for :users, :controllers =>{:omniauth_callbacks =>"users/omniauth_callbacks" }
  root 'main#work'
  get 'users/new'
  resources :users

  get '/main/work', to: 'main#work'
  get '/show/pages', to: 'main#pages'

  #json
  get '/api/users', to: 'apis#users' 			#모든 user들의 정보
  get '/api/user_ids', to: 'apis#user_ids' 		#모든 user들의 id들
  get '/api/user/:id', to: 'apis#user'			#해당 user의 정보 
  get '/api/user/:id/works', to: 'apis#works'	#해당 user의 work들의 정보 
  get '/api/user/:id/work_ids', to: 'apis#work_ids'	#해당 user의 work id들 
  get '/api/work/:id', to: 'apis#work'			#해당 work의 정보
  get '/api/work/:id/branches', to: 'apis#branches' #해당 work의 branch들의 정보
  get '/api/work/:id/branche_ids', to: 'apis#branche_ids' #해당 work의 branch id들
  get '/api/work/:id/tree', to: 'apis#tree'		#해당 work의 tree
  get '/api/branch/:id', to: 'apis#branch'		#해당 branch의 정보 
  get '/api/branch/:id/pages', to: 'apis#pages' #해당 branch의 page들의 정보 
  get '/api/branch/:id/page_ids', to: 'apis#page_ids' #해당 branch의 page id들
  get '/api/page/:id', to: 'apis#page'			#해당 page의 정보 
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
