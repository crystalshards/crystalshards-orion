require "./dependency/*"

module Manifest::Shard::Dependency
  alias Provider = Bitbucket | Git | Github | Gitlab | Path
end
