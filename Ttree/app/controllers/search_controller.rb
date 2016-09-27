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

	def autocomplete
    render :json => {"data":
		{
			"work": Work.search(params[:query], fields: [{name: :text_start}], limit: 5).map{|w| {"id": w.id, "name": w.name}},
			"user": User.search(params[:query], fields: [{email: :text_start}], limit: 5).map(&:email),
			"branch": Branch.search(params[:query], fields: [{name: :text_start}], limit: 5).map(&:name),
			"page": Page.search(params[:query], fields: [{title: :text_start, url: :text_start}], limit: 5).map{|p| {"title": p.title, "url": p.url}}
		}}
		#render json: Work.search(params[:query], fields: [{name: :text_start}], limit: 5).map(&:name)
  end

end
