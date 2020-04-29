.row
  .col-8
    .mb-4
      h1
        = shard.name
        small.text-muted
          span="v#{shard.version}"
      = Emoji.emojize(shard.description || shard.project.description || "No Description")
    h5.font-weight-light.font-italic.text-muted
      | add to shard.yml under
      kbd.bg-dark dependencies
      | or
      kbd.bg-dark development_dependencies

    = render partial: "code_block.ecr"
    h3 Readme
  .col-4

