router Server do
  static "/assets", "./src/assets"
  root to: "home#home"
  resources :shards
end

require "./controllers/*"
