router Server do
  root to: "home#home"
  resources :shards
end

require "./controllers/*"
