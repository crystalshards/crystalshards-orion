class Service::Github::REST::RepositorySearch
  JSON.mapping(
    total_count: Int32,
    items: Array(Github::REST::Repository)
  )

  def self.total_count(*, pushed_before : Time? = nil)
    fetch(pushed_before: pushed_before).total_count
  end

  def self.fetch(per_page = 100, page = 1, *, pushed_before : Time? = nil)
    if pushed_before
      date_filter = pushed_before.to_s("%Y-%m-%d")
      before_date = date_filter.empty? ? "" : "+pushed:<=#{date_filter}"
    end
    REST::Response(self).fetch("repositories", q: "language:Crystal#{before_date}", per_page: per_page, page: page, sort: "updated")
  end

  def self.fetch_repos(*args, **opts)
    fetch(*args, **opts).items
  end
end
