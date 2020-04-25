class HomeController < ApplicationController
  @hero_text = "Under Construction"

  def home
    project_count = Project.query.count
    shard_count = Shard.query.distinct("project_id").count
    author_count = Author.query.count
    version_count = Shard.query.count
    dependency_count = ShardDependency.query.count
    render view: "home.slang"
  end
end
