require "./github/**"

module Service::Github
  extend self

  def fetch(node_ids : Array(String))
    Github::GraphQL::MultiRepositoryQuery.fetch(node_ids: node_ids).repos
  end

  def fetch(url : String)
    Github::GraphQL::RepositoryResourceQuery.fetch(url: url).repo
  end

  def get_by_language(*args, **opts)
    Github::REST::RepositorySearch.fetch_repos(**opts)
  end

  def total_by_language(*, pushed_before : Time? = nil)
    Github::REST::RepositorySearch.total_count
  end

  def total_pages_by_language(*, per_page = 100, pushed_before : Time? = nil)
    (total_by_language(pushed_before: pushed_before) / per_page).ceil.to_i
  end

  def get_by_shardfile(*args, **opts)
    Github::REST::ShardSearch.fetch_repos(**opts)
  end

  def total_by_shardfile
    Github::REST::ShardSearch.total_count
  end

  def total_pages_by_shardfile(*, per_page = 100)
    (total_by_shardfile / per_page).ceil.to_i
  end
end
