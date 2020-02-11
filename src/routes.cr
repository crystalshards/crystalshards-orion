router Server do
  static path: "/assets", dir: "./src/assets"
  root to: "home#home"
  resources :shards
end

require "./controllers/*"
