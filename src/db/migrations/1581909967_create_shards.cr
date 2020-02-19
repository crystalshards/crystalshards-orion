class CreateShards
  include Clear::Migration

  def change(dir)
    create_table(:shards, :uuid) do |t|
      t.references "projects", type: :uuid, null: false
      t.column :ref_type, :ref_type, index: true, null: false
      t.column :ref_name, :string, index: true, null: false
      t.column :license, :string, index: true
      t.column :name, :string
      t.column :description, :string
      t.column :crystal, :string
      t.column :executables, :string, array: true
      t.column :tags, :string, array: true
      t.timestamps
    end
  end
end
