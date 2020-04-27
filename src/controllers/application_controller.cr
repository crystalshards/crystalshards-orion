class ApplicationController < CrystalShards::BaseController
  HEADER_LINKS = {
    "Home"     => "/",
    "Shards"   => "/shards",
    "Projects" => "/projects",
    "Tags"     => "/tags",
    "Authors"  => "/authors",
    # "Docs"     => "/docs",
    # "CLI"      => "/cli",
    # "API"      => "/api",
  }

  @title = "CrystalShards.org"
  @hero_text : String?
  @show_search : Bool = true
  @search_placeholder : String = "Search Shards"

  layout "application_layout.slang"
end
