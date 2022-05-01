require_relative "./package-installation"
require_relative "./users"

module Docker extend self

  def setup()
    puts ""
    puts "==> Starting Docker setup"
    unless PackageInstallation.check("docker")
      puts "Installing docker"
      PackageInstallation.install(%w( dnf-plugins-core ))
      PackageInstallation.add_repo("https://download.docker.com/linux/fedora/docker-ce.repo")
      PackageInstallation.install(%w( docker-ce docker-ce-cli containerd.io docker-compose-plugin ))
      system("systemctl start docker")
      system("echo -e '#!/bin/bash\ndocker compose \"$@\"' >> /usr/bin/docker-compose")
      system("chmod a+x /usr/bin/docker-compose")
      puts "Docker installation complete"
    end

    system("systemctl enable docker")
    system("systemctl enable containerd")
    Users.add_user_to_groups(ENV["KYOTO_USER_NAME"], %w( docker ))
    puts "==> Docker setup complete"
  end

  def check_and_create_volume(volume_name)
    unless system("docker volume ls -q | grep -w #{volume_name}")
      puts ("Creating docker volume")
      system("docker volume create #{volume_name}")
    end
  end

  def check_and_create_network(network_name)
    unless system("docker network ls | grep -w #{network_name}")
      puts ("Creating docker network")
      system("docker network create #{network_name}")
    end
  end

  def run_one_instance(image:, name:, ports: [], volumes: [], environment: [], labels_file: nil, restart_policy: "no")
    check_and_create_network("kyoto")
    unless system("docker ps --filter name=#{name} | grep -vq CONTAINER")
      puts "Starting docker instance #{name} -> #{image}"
      port_mapping = ports.map { |p| p.split(/:/)[0].to_i < 9000 ? "-p #{p}" : "-p 127.0.0.1:#{p}" }.join(" ")
      volume_mapping = volumes.map { |v| "-v #{v}" }.join(" ")
      env_var_mapping = environment.map { |e| "-e #{e}" }.join(" ")
      label_mapping = labels_file.nil? ? "" : "--label-file #{labels_file}"
      system("docker run --net kyoto -d #{port_mapping} #{env_var_mapping} --name #{name} --restart=#{restart_policy} #{volume_mapping} #{label_mapping} #{image}")
    end
  end
end
