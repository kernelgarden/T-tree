class Branch < ApplicationRecord
  #include Searchable
  has_ancestry
  belongs_to :work
  validates:name, presence:true, length:{maximum:50}
  validates:work_id, presence:true

  has_many :pages, :dependent => :destroy

  searchkick text_start: [:name]

  def self.json_tree(nodes)
   	nodes.map do |node, sub_nodes|
      	{:name => node.name, :id => node.id, :work_id => node.work_id, :pages => node.pages.as_json(only:[:id, :name]), :children => Branch.json_tree(sub_nodes).compact}
    end
  end

  def self.json_search(nodes)
    nodes.map do |node|
        {:name => node.name, :id => node.id, :attr =>"Branch", :description => Work.find(node.work_id).name}
    end
  end

end
