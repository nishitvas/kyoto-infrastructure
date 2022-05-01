require_relative "./apps/traefik"
require_relative "./apps/portainer"
require_relative "./apps/oauth"

module Applications extend self

  def setup()
    puts ""
    puts "==> Starting Apps setup"

    Traefik.setup()
    OAuth.setup()
    Portainer.setup()

    puts "==> Apps setup complete"
  end
end
