Rails.application.config.active_record.belongs_to_required_by_default = false
class Unclassifiedpage < ApplicationRecord
  belongs_to :user

  #순서 최근 순으로 
  #default_scope  { order(:created_at => :desc) }
  validates:title, presence:true, length:{maximum:50}
  validates:user_id, presence:true
end
