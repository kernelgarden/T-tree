class Branch < ApplicationRecord
  #include Searchable
  has_ancestry
  belongs_to :work
  validates:name, presence:true, length:{maximum:50}
  validates:work_id, presence:true

  has_many :pages, :dependent => :destroy

  searchkick text_start: [:name]

  def self.json_tree(nodes)
   	nodes.map do |parent, children|
      	{:name => parent.name, :id => parent.id, :work_id => parent.work_id, :pages => parent.pages.as_json(only:[:id, :name]), :children => Branch.json_tree(children).compact}
      	#{:text => node.name, :children => Branch.json_tree(sub_nodes).compact}
    end
  end

  def self.json_tree2(nodes)
	  nodes.map do |parent|
      	{:name => parent.name}
    end
	end

  def self.json_search(nodes)
    nodes.map do |node|
    	if node.id==node.root_id
        {:id => node.id, :parent => "#", :name => node.name, :data => {:ancestry => "null"}}
      else
      	{:id => node.id, :parent => Branch.find(node.parent_id).id, :name => node.name, :data => {:ancestry => node.ancestry}}
      end
    end
  end


end
