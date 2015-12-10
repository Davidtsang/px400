class Blacklist < ActiveRecord::Base
  belongs_to :user
  belongs_to :block_user , class_name: "User"
  validates_uniqueness_of :user_id, scope: :block_user_id

end
