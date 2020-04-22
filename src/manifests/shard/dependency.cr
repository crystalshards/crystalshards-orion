require "./dependency/*"

module Manifest::Shard::Dependency
  alias Provider = Manifest::Shard::Dependency::Bitbucket | Manifest::Shard::Dependency::Git | Manifest::Shard::Dependency::Github | Manifest::Shard::Dependency::Gitlab | Manifest::Shard::Dependency::Path
end
