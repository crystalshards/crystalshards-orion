class AddPushedAtToShard
  include Clear::Migration

  def change(dir)
    add_column "shards", "pushed_at", "timestamp without time zone", nullable: true
  end
end
