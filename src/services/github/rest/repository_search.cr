class Service::Github::REST::RepositorySearch
  JSON.mapping(
    total_count: Int32,
    items: Array(Github::REST::Repository)
  )

  def self.total_count
    fetch.total_count
  end

  def self.fetch(per_page, page, *, updated_before : Time? = nil)
    headers = HTTP::Headers.new
    headers["Authorization"] = "Bearer #{GITHUB_TOKEN}"
    if updated_before
      date_filter = updated_before.to_s("%Y-%m-%d")
      before_date = date_filter.empty? ? "" : "+pushed:<=#{date_filter}"
    end
    url = "https://api.github.com/search/repositories?q=language:Crystal#{before_date}&sort=updated&per_page=#{per_page}&page=#{page}"
    response = HTTP::Client.get(url, headers)
    raise Exception.new("Bad response: #{response.body}") if response.status_code != 200
    from_json(response.body)
  end

  def self.fetch_repos(*args, **opts)
    fetch(*args, **opts).items
  end
end
