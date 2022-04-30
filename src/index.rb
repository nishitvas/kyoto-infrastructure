require_relative "./core/users"
require_relative "./core/docker"
require_relative "./applications"

# Create login user
Users.create_user(ENV["KYOTO_USER_NAME"], password: ENV["KYOTO_USER_PASS"], with_home_dir: true, groups: ["wheel"])

# Setup Docker
Docker.setup()

# Setup Applications
Applications.setup()
