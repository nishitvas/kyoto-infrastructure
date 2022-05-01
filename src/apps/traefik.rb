require_relative "../core/docker"

module Traefik extend self

  def setup()
    puts ""
    puts "==> Starting Traefik setup"

    config_dir = "#{__dir__}/../../config/traefik"

    Docker.check_and_create_volume("acme")

    Docker.run_one_instance(
      image: "traefik:v2.6",
      name: "traefik",
      ports: [ "80:80", "443:443" ],
      volumes: [
        "/var/run/docker.sock:/var/run/docker.sock",
        "#{config_dir}/config.yaml:/etc/traefik/traefik.yml",
        "#{config_dir}/dynamic:/etc/traefik/dynamic",
        "acme:/etc/traefik/acme"
      ],
      restart_policy: "always",
      labels_file: getLabelsFile("traefik")
    )

    # SELinux: Allow traefik to connect to other TCP ports
    system("setsebool -P httpd_can_network_connect 1")

    puts "==> Traefik setup complete"
  end

  def getLabelsFile(app_name)
    return "#{__dir__}/../../config/traefik/labels/#{app_name}.labels"
  end
end
