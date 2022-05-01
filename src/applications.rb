require_relative "./apps/traefik"
require_relative "./apps/portainer"

module Applications extend self

  def setup()
    puts ""
    puts "==> Starting Apps setup"

    Traefik.setup()
    Portainer.setup()

    puts "==> Apps setup complete"
  end
end
