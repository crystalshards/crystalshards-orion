nav.navbar.navbar-expand-lg.navbar-light.bg-light
  .mt-1
    a.navbar-brand href="/"
      img height=40 src="/assets/logo.svg" alt="CrystalShards"
      span.brandfont CrystalShards
  button.navbar-toggler type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"
    span.navbar-toggler-icon
  div.collapse.navbar-collapse#navbarSupportedContent
    ul.navbar-nav.mr-auto.text-uppercase
      - HEADER_LINKS.each do |name, link|
        - active = request.path == link
        li class="nav-item#{active ? " active" : ""}"
          a.nav-link.ml-4 href=link
            = name
            - if active
              span.sr-only
  ul.navbar-nav.mr-auto.d-none.d-lg-flex
    li.m-2
      a.nav-link href="https://github.com/crystalshards"
        i.fab.fa-github
    li.m-2
      a.nav-link href="https://gitlab.com/crystalshards"
        i.fab.fa-gitlab
    li.m-2
      a.nav-link href="#"
        i.fab.fa-twitter
