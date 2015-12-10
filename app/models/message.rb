class Message < ActiveRecord::Base

  MSG_STATUS_RECEIVER_NO_DISPLAY = -1

  belongs_to :from_user , class_name: "User"

  belongs_to :to_user, class_name: "User"

  validates :content, presence: true

  validates_presence_of :to_user_id, :from_user_id

  scope :receive_default,  ->{where(status: 0)}
end
