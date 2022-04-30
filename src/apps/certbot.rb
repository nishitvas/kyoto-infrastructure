require_relative "../core/package-installation"

module Certbot extend self

  def setup()
    puts ""
    puts "==> Staring Certbot setup"
    unless PackageInstallation.check("snap")
      puts "Installing snapd"
      PackageInstallation.install(%w( snapd ))
      system("ln -s /var/lib/snapd/snap /snap")
    end

    unless PackageInstallation.check("certbot")
      puts "Installing certbot"
      PackageInstallation.remove(%w( certbot ))
      system("snap install --classic certbot")
      system("ln -s /snap/bin/certbot /usr/bin/certbot")
    end

    system("certbot --nginx --non-interactive --agree-tos -m #{ENV["KYOTO_USER_EMAIL"]} --domains #{ENV["KYOTO_DOMAINS"]}")

    puts "==> Certbot setup complete"
  end
end
