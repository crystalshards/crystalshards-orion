class CreateRefTypeEnum
  include Clear::Migration

  def change(dir)
    create_enum("ref_type", %w(version commit tag branch))
  end
end
