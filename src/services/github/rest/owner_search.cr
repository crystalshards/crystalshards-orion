class Service::Github::REST::OwnerSearch
  JSON.mapping(
    total_count: Int32,
    items: Array(Github::REST::Owner)
  )

  def self.total_count(*, pushed_before : Time? = nil)
    fetch(pushed_before: pushed_before).total_count
  end

  def self.fetch(per_page = 100, page = 1, *, q)
    REST::Response(self).fetch("users", q: q, per_page: per_page, page: page)
  end

  def self.fetch_repos(*args, **opts)
    fetch(*args, **opts).items
  end
end
