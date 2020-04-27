class Shard
  include Clear::Model

  # Columns
  primary_key
  column manifest : Manifest::Shard
  column name : String
  column version : String
  column git_tag : String?
  column license : String?
  column description : String?
  column crystal : String?
  column tags : Array(String)?

  timestamps

  # Associations
  belongs_to project : Project
  has_many dependencies : ShardDependency, foreign_key: "parent_id"
  has_many authors : Author, through: "shard_authors"

  # Copy spec data to shard
  before :validate do |model|
    model.as(self).update_from_manifest!
  end

  after :save do |model|
    model.as(self).associate_authors!
    model.as(self).associate_dependencies!
  end

  after :create do |model|
    model.as(self).associate_authors!
    model.as(self).associate_dependencies!
  end

  scope :by_project do
    cte = Clear::SQL
      .select("id", "rank() OVER (PARTITION BY shards.project_id ORDER BY shards.created_at DESC NULLS LAST) AS created_rank")
      .from(:shards)
      .where { git_tag == version }
    with_cte({ranked: cte}).where { ranked.created_rank == 1 }
      .inner_join("ranked") { ranked.id == shards.id }
  end

  scope :releases do
    where { shards.git_tag == shards.version }
  end

  scope :recent do
    releases
      .by_project
      .inner_join("projects") { projects.id == shards.project_id }
      .order_by("projects.pushed_at", "DESC", "NULLS LAST")
  end

  scope :popular do
    releases
      .by_project
      .inner_join("projects") { projects.id == shards.project_id }
      .order_by("projects.star_count", "DESC", "NULLS LAST")
  end

  scope :with_uses do
    cte =
      Clear::SQL.select("COUNT(DISTINCT shards.project_id) AS use_count", "dependencies.id")
        .from("shards")
        .inner_join("shard_dependencies") { shard_dependencies.parent_id == shards.id }
        .inner_join("projects AS dependencies") { shard_dependencies.dependency_id == dependencies.id }
        .group_by("dependencies.id")
        .order_by("use_count")
    with_cte({uses: cte}).inner_join("uses") { shards.project_id == uses.id }
  end

  scope :most_used do
    releases
      .by_project
      .with_uses
      .order_by("use_count": "DESC")
  end

  protected def update_from_manifest!
    self.name = manifest.name
    self.version = manifest.version
    self.license = manifest.license
    self.description = manifest.description
    self.crystal = manifest.crystal
    self.tags = manifest.tags
  end

  protected def associate_dependencies!
    # Associate release deps
    (manifest.dependencies || {} of String => Manifest::Shard::Dependency::Provider).each do |name, dependency|
      if (dep = ShardDependency.associate(self, name, dependency))
        self.dependencies << dep
      end
    end

    # Associate development deps
    (manifest.development_dependencies || {} of String => Manifest::Shard::Dependency::Provider).each do |name, dependency|
      if (dep = ShardDependency.associate(self, name, dependency, true))
        self.dependencies << dep
      end
    end
  end

  protected def associate_authors!
    (manifest.authors || [] of Manifest::Shard::Author).each do |manifest_author|
      self.authors << Author.query.find_or_create({name: manifest_author.name, email: manifest_author.email}) { }
    end
  end
end
