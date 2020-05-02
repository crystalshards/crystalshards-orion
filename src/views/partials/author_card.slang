.col-12.col-lg-6.d-flex.align-items-stretch.my-3
  a.card.text-decoration-none.text-body.w-100 href="/authors/#{author.email || author.name}"
    .card-body
      img height=100 src="/authors/#{author.email || author.name}/avatar"
      div = author.name
    .card-footer.text-muted.font-weight-lighter
      i.fa.fa-code
      span = pluralize(author.attributes["shard_count"].as(Int64), "Shard")
      i.fa.fa-coffee.ml-2
      span = pluralize(author.attributes["use_count"].as(Int64), "Uses")
