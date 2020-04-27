class ShardsController < ApplicationController
  def index
    @hero_text = "Shard Directory"
    render view: "shards/index.slang"
  end

  def show
    @hero_text = "Shard Detail"
    render view: "shards/show.slang"
  end
end
