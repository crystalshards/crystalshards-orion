class ShardsController < ApplicationController
  def index
    @hero_text = "Shard Directory"
    shards = Shard.originals.where_valid.with_project.order_by(name: "ASC")
    case (starts_with = request.query_params["starts_with"]?)
    when /[a-z]/i
      shards = shards.where { name =~ /^#{starts_with}/i }
    when "0-9"
      shards = shards.where { name =~ /^[0-9]/i }
    end
    total_count = shards.count
    total_pages = (total_count / per_page).ceil.to_i
    shards = shards.limit(per_page).offset((current_page - 1) * per_page)
    current_count = shards.count
    start_index = ((current_page - 1) * per_page) + 1
    end_index = [(current_page * per_page), total_count].min
    render view: "shards/index.slang"
  end

  def search
    @hero_text = "Search Shards"
    shards =
      Shard
        .originals
        .where_valid
        .with_project
        .includes_uses
        .search(request.query_params["q"]?.to_s)
        .order_by("use_count", "DESC", "NULLS LAST")

    total_count = shards.count
    total_pages = (total_count / per_page).ceil.to_i
    shards = shards.limit(per_page).offset((current_page - 1) * per_page)
    current_count = shards.count
    start_index = ((current_page - 1) * per_page) + 1
    end_index = [(current_page * per_page), total_count].min
    render view: "shards/search.slang"
  end

  def show
    response.headers["Content-Type"] = "text/html"
    @hero_text = "Shard Detail"
    if (shard = version ? shard_by_version : latest_shard)
      render view: "shards/show.slang"
    end
  end

  private def uri
    request.path_params["uri"] + request.format
  end

  private def latest_shard
    Shard.by_provider(request.path_params["provider"]).latest_in_project.find({uri: uri})
  end

  private def version
    request.query_params["v"]?
  end

  private def shard_by_version
    v = version
    Shard.by_provider(request.path_params["provider"]).find { (projects.uri == uri) & ((shards.git_tag == "v#{v}") | (shards.version == v)) }
  end
end
