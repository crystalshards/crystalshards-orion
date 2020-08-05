html lang="en"
  head
    title=locals[:title]
    link href="https://fonts.googleapis.com/css2?family=Righteous&display=swap" rel="stylesheet"
    link href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300;0,400;0,600;0,700;0,800;1,300;1,400;1,600;1,700;1,800&display=swap" rel="stylesheet"
    link rel="apple-touch-icon" sizes="180x180" href="/assets/icons/apple-touch-icon.png"
    link rel="icon" type="image/png" sizes="32x32" href="/assets/icons/favicon-32x32.png"
    link rel="icon" type="image/png" sizes="16x16" href="/assets/icons/favicon-16x16.png"
    link rel="manifest" href="/assets/icons/site.webmanifest"
    link rel="mask-icon" href="/assets/icons/safari-pinned-tab.svg" color="#5bbad5"
    link rel="shortcut icon" href="/assets/icons/favicon.ico"
    == stylesheet_link_tag("main")
    == stylesheet_link_tag("highlight")
    == stylesheet_link_tag("bootstrap")
    script async=true defer=true src="https://buttons.github.io/buttons.js"
    script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"
    script src="https://kit.fontawesome.com/dcc04e440a.js" crossorigin="anonymous"
    == javascript_include_tag("bootstrap.bundle.min")
    == javascript_include_tag("highlight.pack", defer: true)
    == javascript_include_tag("main", defer: true)
    script async=true src="https://www.googletagmanager.com/gtag/js?id=UA-26446640-2"
    javascript:
      window.dataLayer = window.dataLayer || [];
      function gtag(){ dataLayer.push(arguments) };
      gtag('js', new Date());
      gtag('config', 'UA-26446640-2');
    meta name="msapplication-TileColor" content="#da532c"
    meta name="msapplication-config" content="/assets/icons/browserconfig.xml"
    meta name="theme-color" content="#ffffff"
    meta charset="utf-8"
    meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"
  body
    header
      == render partial: "header.slang"
    - if locals[:show_search]
      .bg-secondary.pt-2.pb-2
        .container
          form.col-10.offset-1.mb-0 action="/shards/search" method="GET"
            .input-group
              .input-group-prepend
                span.input-group-text
                  i.fa.fa-search
              input.form-control name="q" type="search" placeholder=locals[:search_placeholder]
    - if locals[:hero_text]
      .jumbotron.rounded-0.py-3
        .container
          h3.mt-1=locals[:hero_text]
    .container
      == yield
    .border-top.pt-2.pb-2.mt-4
      footer.container
        == render partial: "footer.slang"

