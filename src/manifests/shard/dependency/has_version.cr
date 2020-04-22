require "./requirement"

module Manifest::Shard::Dependency::HasVersion
  macro included
    getter version : Manifest::Shard::Dependency::Requirement?
  end
end
