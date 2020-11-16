class HomeController < ApplicationController
  @hero_text = "Shards from the Crystal Community"

  def home
    render view: "home.slang", locals: {
      recently_released: Shard.recently_released.with_project.limit(8),
      most_popular: Shard.popular.with_project.limit(8),
      most_used: Shard.most_used.with_project.limit(8)
    }
  end

  def stats
    render view: "stats.slang", locals: {
      project_count: Project.query.count,
      shard_count: Shard.query.distinct("project_id").count,
      author_count: Author.query.count,
      version_count: Shard.query.count,
      dependency_count: ShardDependency.query.count
    }
  end
end
