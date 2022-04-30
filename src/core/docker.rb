require_relative "./package-installation"
require_relative "./users"

module Docker extend self

  def setup()
    puts ""
    puts "==> Staring Docker setup"
    unless PackageInstallation.check("docker")
      puts "Installing docker"
      PackageInstallation.install(%w( dnf-plugins-core ))
      PackageInstallation.add_repo("https://download.docker.com/linux/fedora/docker-ce.repo")
      PackageInstallation.install(%w( docker-ce docker-ce-cli containerd.io docker-compose-plugin ))
      system("systemctl start docker")
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

  def run_one_instance(image:, name:, ports: [], volumes: [], environment: [], restart_policy: "no")
    unless system("docker ps | grep -q #{name}")
      puts "Starting docker instance #{name} -> #{image}"
      port_mapping = ports.map { |p| "-p #{p}" }.join(" ")
      volume_mapping = volumes.map { |v| "-v #{v}" }.join(" ")
      env_var_mapping = environment.map { |e| "-e #{e}" }.join(" ")
      system("docker run -d #{port_mapping} #{env_var_mapping} --name #{name} --restart=#{restart_policy} #{volume_mapping} #{image}")
    end
  end
end
