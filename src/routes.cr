router Server do
  static path: "/assets", dir: "./src/assets"
  root to: "home#home"
  get "/github", format: "json" do |c|
    c.response.puts Github.fetch_repos(Github::REST::ShardSearch, page: 1).to_json
  end
  resources :shards
end

require "./controllers/*"
