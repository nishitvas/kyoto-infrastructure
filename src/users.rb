module Users

  def check_user_exists(username)
    ret_val = system("getent passwd #{username} &> /dev/null")
    ret_val == true
  end

  def add_user_to_groups(username, groups)
    system("usermod -a -G #{groups.join(",")} #{username}")
  end

  def create_user(username, password: "", with_home_dir: false, groups: [])
    if (username.nil?)
      raise "Username is empty"
    end

    if (check_user_exists(username))
      puts "User #{username} already exists"
    else
      puts "User #{username} does not exist, creating"
      password_cmd = ""
      if (password != "")
        password_cmd = "-p #{password}"
      end

      homedir_cmd = ""
      if (with_home_dir)
        homedir_cmd = "-m"
      end

      system("useradd #{homedir_cmd} #{password_cmd} #{username}")

      if (!groups.empty?)
        add_user_to_groups(username, groups)
      end
    end
  end
end
