.row
  .col-4
    h4 Recently Updated
    - recently_updated.each do |shard|
      = render partial: "shard_card.slang"
