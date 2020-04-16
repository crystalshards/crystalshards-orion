class Service::Github::REST::ShardSearch
  JSON.mapping(
    total_count: Int32,
    items: Array(Github::REST::File)
  )

  def self.total_count
    fetch.total_count
  end

  def self.fetch(per_page = 100, page = 1)
    headers = HTTP::Headers.new
    headers["Authorization"] = "Bearer #{GITHUB_TOKEN}"
    url = "https://api.github.com/search/code?q=path:/+filename:shard.yml&per_page=#{per_page}&page=#{page}&sort=indexed"
    response = HTTP::Client.get(url, headers)
    raise Exception.new("Bad response: #{response.status_code}") if response.status_code != 200
    from_json(response.body)
  end

  def self.fetch_repos(*args, **opts)
    fetch(*args, **opts).items.map(&.repository)
  end
end
