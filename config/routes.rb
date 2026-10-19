if Typus.draw_routes
  Rails.application.routes.draw do
    Typus.routes(self)
  end
end
