require_relative "../core/docker"

module Traefik extend self

  def setup()
    puts ""
    puts "==> Staring Traefik setup"

    config_dir = "#{__dir__}/../../config/traefik"

    Docker.check_and_create_volume("acme")

    Docker.run_one_instance(
      image: "traefik:v2.6",
      name: "traefik",
      ports: [ "80:80", "443:443" ],
      volumes: [
        "/var/run/docker.sock:/var/run/docker.sock",
        "#{config_dir}/config.yaml:/etc/traefik/traefik.yml",
        "acme:/etc/traefik/acme"
      ],
      restart_policy: "always",
      labels: getTraefikDashboardLabels()
    )

    # SELinux: Allow traefik to connect to other TCP ports
    system("setsebool -P httpd_can_network_connect 1")

    puts "==> Traefik setup complete"
  end

  def getLabels(app_name:, path_prefix:, port: nil, service_name: nil)
    service_name = service_name.nil? ? app_name : service_name
    return [
      "traefik.http.routers.#{app_name}.entrypoints=websecure",
      "traefik.http.routers.#{app_name}.service=#{service_name}",
    ] + getTraefikCertLabels(app_name) + getTraefikPathLabels(app_name, path_prefix) + getTraefikPortLabels(service_name, port: port)
  end

  def getTraefikDashboardLabels()
    return [
      "traefik.http.routers.traefik.entrypoints=websecure",
      "traefik.http.routers.traefik.service=api@internal",
      "traefik.http.routers.traefik.rule=PathPrefix(`/dashboard`) || PathPrefix(`/api`)",
    ] + getTraefikCertLabels("traefik")
  end

  def getTraefikCertLabels(app_name)
    return [
      "traefik.http.routers.#{app_name}.tls.certresolver=defaultCertResolver",
      "traefik.http.routers.#{app_name}.tls.domains[0].main=kyoto.nishitvas.com",
      "traefik.http.routers.#{app_name}.tls.domains[1].main=kyoto.nishitvas.dev",
      "traefik.http.routers.#{app_name}.tls.domains[2].main=kyoto.nishitvas.me",
    ]
  end

  def getTraefikPathLabels(app_name, path_prefix)
    return [
      "traefik.http.routers.#{app_name}.rule=PathPrefix(`#{path_prefix}`)",
      "traefik.http.routers.#{app_name}.middlewares=#{app_name}-strip-prefix",
      "traefik.http.middlewares.#{app_name}-strip-prefix.stripprefix.prefixes=#{path_prefix}",
    ]
  end

  def getTraefikPortLabels(service_name, port: nil)
    if port.nil?
      return []
    else
      return ["traefik.http.services.#{service_name}.loadbalancer.server.port=#{port}"]
    end
  end
end
