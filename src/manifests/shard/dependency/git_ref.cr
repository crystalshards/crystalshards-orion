module Manifest::Shard::Dependency::GitRef
  macro included
    getter tag : String?
    getter branch : String?
    getter commit : String?

    def ref_type
      case self
      when .commit
        "commit"
      when .branch
        "branch"
      when .tag
        "tag"
      else
        nil
      end
    end

    def ref_name
      commit || branch || tag
    end
  end
end
