class Domain < Tag

  HOT_DOMAINS =[12,2,45,19,23,26,27,30,47,39,16,32]

  def self.hot_domains

    where(id: HOT_DOMAINS )
  end

  def self.other_domains

    where.not(id: HOT_DOMAINS)
  end

  def self.all_to_options
    all.map{|d| [d.name, d.id]}
  end
end