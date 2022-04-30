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

  def run_one_instance(image:, name:, port_mappings: [], volume_mappings: [], restart_policy: "no")
    unless system("docker ps | grep -q #{name}")
      puts "Starting docker instance #{} -> #{}"
      port_mapping = port_mappings.map { |p| "-p #{p}" }.join(" ")
      volume_mapping = volume_mappings.map { |v| "-v #{v}" }.join(" ")
      system("docker run -d #{port_mapping} --name #{name} --restart #{restart_policy} #{volume_mappings} #{image}")
    end
  end
end
