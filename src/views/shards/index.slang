.row
  .col-12
    = render partial: "directory_nav.slang"
.row
  .col-12
    | Displaying shards
    = "#{start_index} - #{end_index} of #{total_count} in total"
    - if starts_with
      | starting with
      span.font-weight-bold #{starts_with.upcase}
.row
  - shards.each do |shard|
    = render partial: "shard_card.slang"
.row
  = render partial: "pagination.slang"
