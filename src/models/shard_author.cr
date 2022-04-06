class ShardAuthor
  include Clear::Model
  include Orion::Cache::Keyable

  define_cache_key self.class.name, id, updated_at

  timestamps

  belongs_to : Author
  belongs_to : Shard
end
