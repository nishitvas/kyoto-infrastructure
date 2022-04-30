require_relative "./users"
require_relative "./docker"

include Users
include Docker

# Create login user
Users::create_user(ENV["KYOTO_USER_NAME"], password: ENV["KYOTO_USER_PASS"], with_home_dir: true, groups: ["wheel"])

# Setup Docker
Docker::setup()
