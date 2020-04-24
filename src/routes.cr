router CrystalShards do
  use HTTP::LogHandler.new
  static path: "/assets", dir: "./src/assets"
  root to: "home#home"
  resources :shards, only: [:show, :index, :new, :create]
end

require "./controllers/*"
