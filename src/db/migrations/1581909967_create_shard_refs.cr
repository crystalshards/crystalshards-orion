class CreateShardRefs
  include Clear::Migration

  def change(dir)
    create_table(:shard_refs, :uuid) do |t|
      t.references "shards", type: :uuid, null: false
      t.column :ref_type, :ref_type, index: true, null: false
      t.column :ref_value, :string, index: true, null: false
      t.column :license, :string, index: true
      t.column :description, :string
      t.column :crystal, :string
      t.column :executables, :string, array: true
      t.column :tags, :string, array: true
      t.timestamps
    end
  end
end
