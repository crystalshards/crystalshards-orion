- first_page = current_page <= 1
- last_page = current_page == total_pages
nav aria-label="Page navigation example"
  ul.pagination.justify-content-center
    li.page-item class="#{first_page ? "disabled" : ""}"
      a.page-link href="#{update_params(page: 1.to_s)}" aria-label="Previous"
        span aria-hidden="true"== "&lsaquo; First"
    li.page-item class="#{first_page ? "disabled" : ""}"
      a.page-link href="#{update_params(page: (current_page - 1).to_s)}" aria-label="Previous"
        span aria-hidden="true"== "&laquo; Prev"
    - (([current_page - 5, 1].max)..(total_pages)).first(10).each do |page_number|
      li.page-item
        a.page-link href="#{update_params(page: page_number.to_s)}"= page_number
    li.page-item class="#{last_page ? "disabled" : ""}"
      a.page-link href="#{update_params(page: (current_page + 1).to_s)}" aria-label="Next"
        span aria-hidden="true"== "Next &rsaquo;"
    li.page-item class="#{last_page ? "disabled" : ""}"
      a.page-link href="#{update_params(page: total_pages.to_s)}" aria-label="Next"
        span aria-hidden="true"== "Last &raquo;"
