.d-flex.d-justify-content-between.flex-fill.mt-3.mb-5.flex-wrap
  a.mx-2.flex-fill href="#{update_params(char: nil)}" aria-label=char class="#{!char ? "font-weight-bolder" : "font-weight-regular"}"
    | All
  a.mx-2.flex-fill href="#{update_params(char: "0-9")}" aria-label=char class="#{char == "0-9" ? "font-weight-bolder" : "font-weight-regular"}"
    | 0-9
  - ("A".."Z").each do |c|
    a.mx-2.flex-fill href="#{update_params(char: c)}" aria-label=char class="#{c == char ? "font-weight-bolder" : "font-weight-regular"}"
      = c
