require_relative "../core/docker"
require_relative "./traefik"

module Portainer extend self

  def setup()
    puts ""
    puts "==> Starting Portainer setup"

    portainer_volume = "portainer_data"
    Docker.check_and_create_volume(portainer_volume)
    Docker.run_one_instance(
      image: "portainer/portainer-ce:2.11.1",
      name: "portainer",
      volumes: [
        "/var/run/docker.sock:/var/run/docker.sock",
        "portainer_data:/data"
      ],
      restart_policy: "always",
      labels_file: Traefik.getLabelsFile("portainer")
    )
    puts "==> Portainer setup complete"
  end
end
