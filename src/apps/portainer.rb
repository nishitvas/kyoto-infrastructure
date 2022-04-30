require_relative "../core/docker"

module Portainer extend self

  def setup()
    puts ""
    puts "==> Staring Portainer setup"

    portainer_volume = "portainer_data"
    Docker.check_and_create_volume(portainer_volume)
    Docker.run_one_instance(
      image: "portainer/portainer-ce:2.11.1",
      name: "portainer",
      port_mapping: [ "9443:9443" ],
      volume_mapping: [
        "/var/run/docker.sock:/var/run/docker.sock",
        "portainer_data:/data"
      ],
      restart_policy: "always"
    )
    puts "==> Portainer setup complete"
  end
end
