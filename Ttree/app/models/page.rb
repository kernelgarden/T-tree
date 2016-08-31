class Page < ApplicationRecord
  #include Searchable
  belongs_to :branch

  #순서 최근 순으로
  #default_scope  { order(:created_at => :desc) }
  validates:title, presence:true, length:{maximum:50}
  validates:branch_id, presence:true

end
