class Page < ApplicationRecord
  #include Searchable
  belongs_to :branch

  #순서 최근 순으로
  #default_scope  { order(:created_at => :desc) }
  validates:title, presence:true
  validates:branch_id, presence:true

  searchkick text_start: [:title, :url], suggest: ["title"]

  def self.json_search(nodes)
    nodes.map do |node|
        { :name => node.title,
        	:id => node.id,
        	:attr =>"Page",
        	:description => Branch.find(node.branch_id).name+" / "+node.created_at.strftime("%Y-%m-%d")}
    end
  end

end
