# Increase log verbosity
log_level = "DEBUG"

# Setup data dir
data_dir = "C:\\nomad\\data_dir"

# Give the agent a unique name. Defaults to hostname
name = "${hostname}"

# Enable the client
client {
    enabled = true

    # For demo assume we are talking to server1. For production,
    # this should be like "nomad.service.consul:4647" and a system
    # like Consul used for service discovery.
    servers = ["10.0.1.50:4647"]

  options = {
    "driver.raw_exec.enable" = "1"
  }
}

# Modify our port to avoid a collision with server1
ports {
    http = 5656
}

