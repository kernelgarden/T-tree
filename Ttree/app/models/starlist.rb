class Starlist < ApplicationRecord
  belongs_to :stared_user, class_name: "User"
  belongs_to :favorate_work, class_name: "Work"

  validates :user_id, presence: true
  validates :work_id, presence: true
end
