class SearchController < ApplicationController

	def getResult
		@users=User.all
		@works=Work.all
		@branches=Branch.all
		@pages=Page.all
  	render :json =>
  	{
  		"users": User.json_search(@users),
  		"works": Work.json_search(@works),
	    "branches": Branch.json_search(@branches),
	    "pages": Page.json_search(@pages)
		}
	end


end
