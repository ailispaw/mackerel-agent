# A dummy plugin for Barge to set hostname and network correctly at the very first `vagrant up`
module VagrantPlugins
  module GuestLinux
    class Plugin < Vagrant.plugin("2")
      guest_capability("linux", "change_host_name") { Cap::ChangeHostName }
      guest_capability("linux", "configure_networks") { Cap::ConfigureNetworks }
    end
  end
end

Vagrant.configure(2) do |config|
  config.vm.define "mackerel-agent"

  config.vm.box = "ailispaw/barge"

  config.vm.synced_folder ".", "/vagrant", id: "vagrant"

  config.vm.provision :shell do |sh|
    sh.inline = <<-EOT
      mkdir -p /opt/mackerel-agent
      cp /vagrant/mackerel-agent.conf /opt/mackerel-agent/mackerel-agent.conf
      cp /vagrant/mackerel-check-container.sh /opt/mackerel-agent/mackerel-check-container.sh
      cp /vagrant/mackerel-check-containers.sh /opt/mackerel-agent/mackerel-check-containers.sh
    EOT
  end

  config.vm.provision :docker do |docker|
    docker.pull_images "busybox"
    docker.run "hello",
      image: "busybox",
      args: "-p 8080:8080 -v /usr/bin/dumb-init:/dumb-init:ro --entrypoint=/dumb-init",
      cmd: "nc -p 8080 -l -l -e echo hello world!"
  end

  config.vm.provision :docker do |docker|
    docker.pull_images "ailispaw/mackerel-agent"
    docker.run "mackerel-agent",
      image: "ailispaw/mackerel-agent",
      args: [
        "--net host",
        "-v /var/run/docker.sock:/var/run/docker.sock",
        "-v /opt/mackerel-agent/:/var/lib/mackerel-agent/",
        "-v /opt/mackerel-agent/mackerel-agent.conf:/etc/mackerel-agent/mackerel-agent.conf"
      ].join(" "),
      cmd: "mackerel-agent -v"
  end

  if Vagrant.has_plugin?("vagrant-triggers") then
    config.trigger.after [:up, :resume], :stdout => false, :stderr => false do
      info "Set status working"
      run_remote <<-EOT
        sh -c '[ -f /opt/mackerel-agent/id ] && \
          docker exec mackerel-agent mkr update --status working || true'
      EOT
    end

    config.trigger.before [:suspend, :halt], :stdout => false, :stderr => false do
      info "Set status poweroff"
      run_remote <<-EOT
        sh -c '[ -f /opt/mackerel-agent/id ] && \
          docker exec mackerel-agent mkr update --status poweroff || true'
      EOT
    end

    config.trigger.before [:destroy], :stdout => false, :stderr => false do
      info "Retire from Mackerel"
      run_remote <<-EOT
        sh -c '[ -f /opt/mackerel-agent/id ] && \
          docker exec mackerel-agent mkr retire || true'
      EOT
    end
  end
end
