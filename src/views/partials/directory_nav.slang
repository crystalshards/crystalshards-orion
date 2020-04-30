.d-flex.d-justify-content-between.flex-fill.mt-3.mb-5.flex-wrap
  a.mx-2.flex-fill href="#{update_params(starts_with: nil, page: nil)}" aria-label=starts_with class="#{!starts_with ? "font-weight-bolder" : "font-weight-regular"}"
    | All
  a.mx-2.flex-fill href="#{update_params(starts_with: "0-9", page: nil)}" aria-label=starts_with class="#{starts_with == "0-9" ? "font-weight-bolder" : "font-weight-regular"}"
    | 0-9
  - ("A".."Z").each do |c|
    a.mx-2.flex-fill href="#{update_params(starts_with: c, page: nil)}" aria-label=starts_with class="#{c == starts_with ? "font-weight-bolder" : "font-weight-regular"}"
      = c
