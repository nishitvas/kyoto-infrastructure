require_relative "./apps/nginx"
require_relative "./apps/portainer"

module Applications extend self

  def setup()
    puts ""
    puts "==> Staring Apps setup"

    Nginx.setup()
    Portainer.setup()
    
    puts "==> Apps setup complete"
  end
end
