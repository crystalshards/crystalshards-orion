require "../../models/enums"
require "../../models/project"

class MigrateUris
  include Clear::Migration

  def change(dir)
    dir.up do
      Project.query.where { ~(provider.in? %w{git path}) }.each_with_cursor(100) do |project|
        project.uri = URI.parse(project.uri).path.lchop
        project.save
      end
    end

    dir.down do
      irreversible!
    end
  end
end
