class BranchSerializer < ActiveModel::Serializer
  attributes :id, :name, :work_id, :child_ids
end