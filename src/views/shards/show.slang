.row
  .col-8
    .mb-5
      h1
        = shard.name
        small.text-muted
          span="v#{shard.version}"
      = shard.formatted_description
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
        == Markd.to_html(readme)

  aside.col-4.border-left
    a.btn.btn-lg.btn-block.btn-outline-primary.text-left href=shard.project.url
      i.mx-3 class="fab fa-#{shard.project.provider.to_s}"
      span=shard.project.uri
    - if (url = shard.homepage_url)
      a.btn.btn-lg.btn-block.btn-outline-primary.text-left href=url.to_s
        i.mx-3.fa.fa-home
        span="#{url.host}#{url.path}"
    - if (url = shard.documentation_url)
      a.btn.btn-lg.btn-block.btn-outline-primary.text-left href=url.to_s
        i.mx-3.fa.fa-book
        span Documentation

