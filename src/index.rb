require_relative "./users"
require_relative "./docker"
require_relative "./nginx"

# Create login user
Users.create_user(ENV["KYOTO_USER_NAME"], password: ENV["KYOTO_USER_PASS"], with_home_dir: true, groups: ["wheel"])

# Setup Docker
Docker.setup()

# Setup Nginx
Nginx.setup()
