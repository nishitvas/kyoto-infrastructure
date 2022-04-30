require "fileutils"
require_relative "./package-installation"

module Nginx extend self

  def setup()
    puts ""
    puts "==> Staring Nginx setup"

    unless PackageInstallation.check("nginx")
      puts "Installing nginx"
      PackageInstallation.install(%w( nginx ))
      system("systemctl start nginx")
      puts "Nginx installation complete"
    end

    puts "Copying nginx configuration"
    FileUtils.cp_r "#{__dir__}/../config/nginx/.", "/etc/nginx", :verbose => true

    system("systemctl enable nginx")
    system("firewall-cmd --permanent --add-port={80/tcp,443/tcp} > /dev/null")
    system("firewall-cmd --reload > /dev/null")
    system("systemctl reload nginx")
    puts "==> Nginx setup complete"
  end
end
