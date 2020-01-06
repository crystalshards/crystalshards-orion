class ApplicationController < Server::BaseController
  getter content : String?

  macro layout(layout_loc)
    LAYOUT = {{ layout_loc }}
  end

  layout "src/templates/application_layout.slang"

  macro render(template_loc)
    @content = Kilt.render({{ template_loc }})
    response.puts Kilt.render({{ LAYOUT }})
  end

  macro partial(template_loc)
    Kilt.render({{ template_loc }})
  end
end
