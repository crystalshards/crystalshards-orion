.mt-3
  h4
    i.fa.fa-star.text-primary
    | Top Authors
  .row
    - most_impactful_authors.each(fetch_columns: true) do |author|
      = render partial: "author_card.slang"
