class CreateAuthors
  include Clear::Migration

  def change(dir)
    create_table(:authors) do |t|
      t.column :name, type: :string, null: false
      t.column :email, type: :string
      t.timestamps
    end
  end
end
