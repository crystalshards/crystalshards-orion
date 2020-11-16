nav.navbar.navbar-expand-lg.navbar-light.bg-light
  .mt-1
    a.navbar-brand href="/"
      == image_tag("logo.svg", height: "40px", alt: "CrystalShards")
      span.brandfont CrystalShards
  button.navbar-toggler type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"
    span.navbar-toggler-icon
  div.collapse.navbar-collapse#navbarSupportedContent
    ul.navbar-nav.mr-auto.text-uppercase
      - locals[:header_links].each do |name, link|
        - active = false
        li class="nav-item#{active ? " active" : ""}"
          a.nav-link.ml-4 href=link
            = name
            - if active
              span.sr-only
  ul.navbar-nav.mr-auto.d-none.d-lg-flex
    li.m-2
      a class="github-button" href="https://github.com/crystalshards/crystalshards" data-size="large" data-show-count="true" aria-label="Star crystalshards/crystalshards on GitHub" Star
    li.m-2
      a.nav-link href="https://gitlab.com/crystalshards"
        i.fab.fa-gitlab
