class AddReadmeToShard
  include Clear::Migration

  def change(dir)
    add_column "shards", "readme", "text", nullable: true
  end
end
