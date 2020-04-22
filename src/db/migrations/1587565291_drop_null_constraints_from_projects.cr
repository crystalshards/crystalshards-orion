class DropNullConstraintsFromProjects
  include Clear::Migration

  def change(dir)
    dir.up do
      execute <<-SQL
        ALTER TABLE projects
        ALTER watcher_count DROP NOT NULL,
        ALTER watcher_count DROP DEFAULT,
        ALTER fork_count DROP NOT NULL,
        ALTER fork_count DROP DEFAULT,
        ALTER star_count DROP NOT NULL,
        ALTER star_count DROP DEFAULT,
        ALTER pull_request_count DROP NOT NULL,
        ALTER pull_request_count DROP DEFAULT,
        ALTER issue_count DROP NOT NULL,
        ALTER issue_count DROP DEFAULT
      SQL
    end

    dir.down do
      execute <<-SQL
        ALTER TABLE projects
        ALTER watcher_count SET NOT NULL,
        ALTER watcher_count SET DEFAULT 0,
        ALTER fork_count SET NOT NULL,
        ALTER fork_count SET DEFAULT 0,
        ALTER star_count SET NOT NULL,
        ALTER star_count SET DEFAULT 0,
        ALTER pull_request_count SET NOT NULL,
        ALTER pull_request_count SET DEFAULT 0,
        ALTER issue_count SET NOT NULL,
        ALTER issue_count SET DEFAULT 0
      SQL
    end
  end
end
