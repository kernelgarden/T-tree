Rails.application.config.active_record.belongs_to_required_by_default = false

class Work < ApplicationRecord
	#include Searchable
	belongs_to :user, optional: true
	belongs_to :team, optional: true
	#순서 최근 순으로
	#default_scope  { order(:created_at => :desc) }
	validates:name, presence:true, length:{maximum:50}

	has_many :branches, :dependent => :destroy
	has_many :starlists, :dependent => :destroy, :foreign_key => "work_id"
	has_many :stared_users, :through => :starlists, class_name: "User"

	#settings index: { number_of_shards: 1 } do
	#  mappings dynamic: 'false' do
	#    indexes :name, analyzer: 'english'
	#  end
	#end

	#def as_indexed_json(options={})
  #  as_json(
  #    only: [:name],
  #    include: [:branches]
  #  )
  #end

  def self.json_search(nodes)
    nodes.map do |node|
        {:name => node.name, :id => node.id, :attr =>"Work", :description => User.find(node.user_id).email}
    end
  end

end
#Work.__elasticsearch__.client.indices.delete index: Work.index_name rescue nil

# Create the new index with the new mapping
#Work.__elasticsearch__.client.indices.create \
#  index: Work.index_name,
#  body: { settings: Work.settings.to_hash, mappings: Work.mappings.to_hash }

# Index all work records from the DB to Elasticsearch
#Work.import force: true
