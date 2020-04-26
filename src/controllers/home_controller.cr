class HomeController < ApplicationController
  @hero_text = "Under Construction"

  def home
    recently_updated = Shard.recent.with_project.limit(20)
    popular = Shard.popular.with_project.limit(20)
    most_used = Shard.most_used.with_project.limit(20)
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
