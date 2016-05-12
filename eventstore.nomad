job "eventstore" {
	datacenters = ["dc1"]

	constraint {
		attribute = "${attr.kernel.name}"
		value = "linux"
	}

	update {
		stagger = "10s"

		max_parallel = 1
	}

	group "eventstore" {
		restart {
			attempts = 10
			interval = "5m"
			delay = "10s"
			mode = "delay"
		}

		task "eventstore" {
			driver = "docker"

			config {
				image = "eventstore/eventstore"
				port_map {
					store = 2113
				}
			}

			service {
				name = "eventstore"
				port = "store"
				check {
					name = "alive"
					type = "tcp"
					interval = "10s"
					timeout = "2s"
				}
			}

			env {
				EVENTSTORE_RUN_PROJECTIONS = "All"
			}

			resources {
				cpu = 500 # 500 Mhz
				memory = 256 # 256MB
				network {
					mbits = 10
					port "store" {
						static = 2113
					}
				}
			}

		}
	}
}
