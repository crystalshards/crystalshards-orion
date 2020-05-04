.row
  .col-8
    .mb-5
      h1
        = shard.name
        small.text-muted
          span="v#{shard.version}"
      = shard.formatted_description
      .my-2
        - shard.tags.each do |tag|
          span.badge.badge-pill.badge-primary
            span.font-weight-light = tag
    .mb-5
      h4.mb-3
        i.fa.fa-code
        | Install & Use
      p
        | Add the following code to your project's shard.yml under:
      p
        kbd.bg-dark dependencies
        span.font-italic to use in production
        br
        span.font-italic - OR -
        br
        kbd.bg-dark development_dependencies
        span.font-italic to use in development
      = render partial: "code_block.ecr"

    - if (readme = shard.readme)
      h4.mb-3
        i.fa.fa-book-open
        | Readme
      #readme.border.rounded.p-4.bg-light
        == shard.readme_html

  aside.col-4.border-left
    .mb-4
      a.btn.btn-block.btn-outline-primary.text-left href=shard.project.url
        i.mx-1 class="fab fa-#{shard.project.provider.to_s}"
        span=shard.project.uri
      - if (url = shard.homepage_url)
        a.btn.btn-block.btn-outline-primary.text-left href=url.to_s
          i.mx-1.fa.fa-home
          span="#{url.host}#{url.path}"
      - if (url = shard.documentation_url)
        a.btn.btn-block.btn-outline-primary.text-left href=url.to_s
          i.mx-1.fa.fa-book
          span Documentation
    .mb-4
      h5 Stats
      .d-flex
        div
          i.fa.fa-star
          | Stars
        div.flex-fill.border-bottom.border-bottom-style-dotted.mb-1.mx-2.border-secondary
        div.font-weight-bold
          = shard.project.star_count || "?"
      .d-flex
        div
          i.fa.fa-exclamation-circle
          | Issues
        div.flex-fill.border-bottom.border-bottom-style-dotted.mb-1.mx-2.border-secondary
        div.font-weight-bold
          = shard.project.issue_count || "?"
      .d-flex
        div
          i.fas.fa-code-branch
          | Pull Requests
        div.flex-fill.border-bottom.border-bottom-style-dotted.mb-1.mx-2.border-secondary
        div.font-weight-bold
          = shard.project.pull_request_count || "?"
      .d-flex
        div
          i.fas.fa-eye
          | Watchers
        div.flex-fill.border-bottom.border-bottom-style-dotted.mb-1.mx-2.border-secondary
        div.font-weight-bold
          = shard.project.watcher_count || "?"
      .d-flex
        div
          i.fas.fa-clone
          | Mirrors/Forks
        div.flex-fill.border-bottom.border-bottom-style-dotted.mb-1.mx-2.border-secondary
        div.font-weight-bold
          = shard.project.mirrors.count
      .d-flex
        div
          i.fas.fa-link
          | Dependents
        div.flex-fill.border-bottom.border-bottom-style-dotted.mb-1.mx-2.border-secondary
        div.font-weight-bold
          = shard.project.dependent_count
    - if shard.dependencies.production.count > 0
      .mb-4
        h5 Dependencies
        - shard.dependencies.production.with_dependency.each do |dep|
          div
            a href="/shards/#{dep.dependency.provider.to_s}/#{dep.dependency.uri}"
              span.font-weight-bold = "#{dep.name}"
              span.font-italic.font-weight-lighter.text-muted = "#{dep.dependency.provider.to_s}: #{dep.dependency.uri}"
    - if (dev_deps = shard.dependencies.development).count > 0
      .mb-4
        h5 Development Dependencies
        - dev_deps.with_dependency.each do |dep|
          div
            a href="/shards/#{dep.dependency.provider.to_s}/#{dep.dependency.uri}"
              span.font-weight-bold = "#{dep.name}"
              span.font-italic.font-weight-lighter.text-muted = "#{dep.dependency.provider.to_s}: #{dep.dependency.uri}"
    - if (versions = shard.project.shards.versions).count > 0
      .mb-4
        h5 Versions
        - current_shard = shard
        - versions.each do |s|
          - weight_class = s.version == current_shard.version ? "bold" : "regular"
          .d-flex
            a href="#{update_params(v: s.version)}"
              div class="font-weight-#{weight_class}" = s.version
            - if (pushed_at = s.pushed_at)
              div.flex-fill.border-bottom.border-bottom-style-dotted.mb-1.mx-2.border-secondary
              div.font-italic.font-weight-lighter.text-muted = pushed_at.to_s("%b %d, %Y")
    - if (authors = shard.authors).count > 0
      .mb-4
        h5 Authors
        - authors.each do |author|
          a.d-flex.align-items-center.mb-2 href="/authors/#{URI.encode(author.email || author.name)}"
            img.rounded.align-left.mr-2 height=25 src=author.avatar_url
            div.font-weight-bold = author.name



