class ApplicationController < CrystalShards::BaseController
  enum PageNav
    Prev
    Next
  end

  HEADER_LINKS = {
    "Home"     => "/",
    "Shards"   => "/shards",
    "Tags"     => "/tags",
    "Authors"  => "/authors"
  }

  @title = "CrystalShards.org"
  @hero_text : String?
  @show_search : Bool = true
  @search_placeholder : String = "Search Shards"
  getter per_page = 30

  layout "application_layout.slang"

  private def current_page
    (request.query_params["page"]? || 1).to_i
  end

  private def update_params(*args, **params)
    next_params = HTTP::Params.parse(request.query_params.to_s)
    params.each do |key, value|
      if value
        next_params[key.to_s] = value
      else
        next_params.delete_all(key.to_s)
      end
    end
    [request.path, next_params.to_s].join("?")
  end
end
