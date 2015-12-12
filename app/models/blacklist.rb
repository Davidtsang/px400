class Blacklist < ActiveRecord::Base
  belongs_to :user
  belongs_to :block_user , class_name: "User"
  validates_uniqueness_of :user_id, scope: :block_user_id


  def self.block_user(user,block_user)

   Blacklist.create(user_id: user.id  , block_user_id: block_user.id )

   if block_user.following?(user)
      block_user.unfollow(user)
   end

  end
end
