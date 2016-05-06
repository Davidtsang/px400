class Skill < Tag

  def self.all_by_users_domain_id(domain_id)
    joins("JOIN users_tags ON users_tags.tag_id = tags.id").joins("JOIN users ON users.id = users_tags.user_id").where("users.domain_1_id = :domain_id OR users.domain_2_id = :domain_id", :domain_id=> domain_id).order(:items_count=>:desc).uniq.limit(100)
  end
end