class ApplicationController < BaseController
  enum PageNav
    Prev
    Next
  end

  view_helper ViewHelper

  @title = "CrystalShards.org"
  @hero_text : String?
  @show_search : Bool = true
  @search_placeholder : String = "Search Shards"
  getter per_page = 30

  layout "application_layout.slang", locals: {
    header_links: {
      "Home"    => "/",
      "Shards"  => "/shards",
      "Authors" => "/authors",
    },
    title: @title,
    hero_text: @hero_text,
    show_search: @show_search,
    search_placeholder: @search_placeholder,
    per_page: per_page,
    current_page: current_page
  }

  private def current_page
    (request.query_params["page"]? || 1).to_i
  end
end
