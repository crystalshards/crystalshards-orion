.row
  .col-4
    h4 Recently Updated
    - recently_updated.each do |shard|
      = render partial: "shard_card.slang"
  .col-4
    h4 Most Starred
    - popular.each do |shard|
      = render partial: "shard_card.slang"
  .col-4
    h4 Most Used
    - most_used.each do |shard|
      = render partial: "shard_card.slang"
