module PackageInstallation extend self

  def check(command)
    ret_val = system("which #{command} &> /dev/null")
    ret_val == true
  end

  def install(commands = [])
    system("dnf -y install #{commands.join(" ")}")
  end

  def remove(commands = [])
    system("dnf -y remove #{commands.join(" ")}")
  end

  def add_repo(repo)
    system("dnf config-manager --add-repo #{repo}")
  end
end
