.row
  .col-12
    | Searching shards containing
    = request.query_params["q"]?
    = "#{start_index} - #{end_index} of #{total_count} in total"
.row
  - shards.each(fetch_columns: true) do |shard|
    = render partial: "shard_card.slang"
.row
  = render partial: "pagination.slang"
