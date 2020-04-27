.d-flex.d-justify-content-between.flex-fill.mt-3.mb-5
  - ("A".."Z").each do |l|
    a.mx-2.flex-fill href="#{update_params(letter: l)}" aria-label=letter class="#{l === letter ? "font-weight-bolder" : "font-weight-regular"}"
      = l
