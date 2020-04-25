class HomeController < ApplicationController
  @hero_text = "Under Construction"

  def home
    recently_updated = Shard.query.inner_join("projects") { projects.id == shards.project_id }.distinct("project_id").order_by("project_id": "ASC", "projects.pushed_at": "DESC").limit(10)
    render view: "home.slang"
  end

  def stats
    project_count = Project.query.count
    shard_count = Shard.query.distinct("project_id").count
    author_count = Author.query.count
    version_count = Shard.query.count
    dependency_count = ShardDependency.query.count
    render view: "stats.slang"
  end
end
