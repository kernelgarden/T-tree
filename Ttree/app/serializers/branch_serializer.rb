class BranchSerializer < ActiveModel::Serializer
  attributes :id, :name, :work_id, :parent_id, :child_ids, :page_ids, :position
  #has_many :pages
end