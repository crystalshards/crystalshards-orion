.col-12.col-lg-6.d-flex.align-items-stretch.my-3
  a.card.text-decoration-none.text-body.w-100 href="/shards/#{shard.project.provider.to_s}/#{shard.project.uri}"
    .card-header
      span.font-weight-bold=shard.name
      span.text-muted="v#{shard.version}"
    .card-body=shard.formatted_description
    .card-footer.text-muted.font-weight-lighter
      i class="fab fa-#{shard.project.provider.to_s}"
      span=shard.project.uri
      - if shard.project.star_count
        i.far.fa-star.ml-2
        span=shard.project.star_count
      - if (use_count = shard.attributes["use_count"]?)
        i.fas.fa-link.ml-2
        span=use_count
      - if shard.project.pushed_at
        i.fas.fa-history.ml-2
        span=shard.project.last_pushed_at_string
