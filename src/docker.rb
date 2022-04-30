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
end
