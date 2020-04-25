require "sass"

router CrystalShards do
  use HTTP::LogHandler.new
  root to: "home#home"
  static path: "/assets/bootstrap.css", string: Sass.compile_file("src/scss/bootstrap/bootstrap.scss", output_style: Sass::OutputStyle::COMPRESSED)
  static path: "/assets", dir: "./src/assets"
  resources :shards, only: [:show, :index, :new, :create]
end

require "./controllers/*"
