.row
  .col-12
    = render partial: "letter_nav.slang"
.row
  .col-12
    | Displaying shards
    = "#{start_index} - #{end_index} of #{total_count} in total"
    - if letter
      | starting with the letter
      span.font-weight-bold #{letter.upcase}
.row
  - shards.each do |shard|
    = render partial: "shard_card.slang"
.row
  = render partial: "pagination.slang"
