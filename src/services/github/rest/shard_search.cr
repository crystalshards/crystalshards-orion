class Service::Github::REST::ShardSearch
  JSON.mapping(
    total_count: Int32,
    items: Array(Github::REST::File)
  )

  def self.total_count
    fetch.total_count
  end

  def self.fetch(per_page = 100, page = 1)
    REST::Response(self).fetch("code", q: "path:/+filename:shard.yml", per_page: per_page, page: page, sort: "indexed")
  end

  def self.fetch_repos(*args, **opts)
    fetch(*args, **opts).items.map(&.repository)
  end
end
