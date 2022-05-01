require_relative "../core/docker"
require_relative "./traefik"

module OAuth extend self

  def setup()
    puts ""
    puts "==> Starting OAuth setup"

    Docker.run_one_instance(
      image: "thomseddon/traefik-forward-auth:2",
      name: "oauth",
      restart_policy: "unless-stopped",
      labels_file: Traefik.getLabelsFile("oauth"),
      environment: [
        "CLIENT_ID=#{ENV["KYOTO_OAUTH_CLIENT_ID"]}",
        "CLIENT_SECRET=#{ENV["KYOTO_OAUTH_CLIENT_SECRET"]}",
        "SECRET=#{ENV["KYOTO_OAUTH_SECRET"]}",
        "COOKIE_DOMAIN=#{ENV["KYOTO_DOMAINS"]}",
        "INSECURE_COOKIE=false",
        "AUTH_HOST=oauth.kyoto.nishitvas.com",
        "URL_PATH=/_oauth",
        "WHITELIST=#{ENV["KYOTO_USER_EMAIL"]}",
        "LOG_LEVEL=warn",
        "LOG_FORMAT=text",
        "LIFETIME=2592000",
        "DEFAULT_ACTION=auth",
        "DEFAULT_PROVIDER=google"
      ]
    )
    puts "==> OAuth setup complete"
  end
end
