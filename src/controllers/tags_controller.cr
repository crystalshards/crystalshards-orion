class TagsController < ApplicationController
  def index
    @hero_text = "Tags"
    render view: "tags/index.slang"
  end

  def show
    response.headers["Content-Type"] = "text/html"
    @hero_text = "Tag Detail"
    render view: "tags/show.slang"
  end
end
