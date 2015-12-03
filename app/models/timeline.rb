class Timeline < ActiveRecord::Base

  belongs_to :user
  belongs_to :work

  self.per_page = 60
end
