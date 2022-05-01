require_relative "./core/users"
require_relative "./core/docker"
require_relative "./applications"

unless ENV["KYOTO_ENV_LOADED"] == "LOADED"
  raise "Kyoto environment variables are not set"
end

# Create login user
Users.create_user(ENV["KYOTO_USER_NAME"], password: ENV["KYOTO_USER_PASS"], with_home_dir: true, groups: ["wheel"])

# Setup Docker
Docker.setup()

# Setup Applications
Applications.setup()
