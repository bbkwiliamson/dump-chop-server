# Template to create the nginx_status_check.sh script
template '/usr/local/bin/nginx_status_check.sh' do
    source 'nginx_status_check.sh.erb'
    mode '0755'
    variables(
      hostname: node['hostname'],
      fqdn: node['fqdn'],
      ipaddress: node['ipaddress']
    )
    action :create
end
  
  # Create the systemd service file
file '/etc/systemd/system/nginx_status_check.service' do
    content <<-EOU
    [Unit]
    Description=Check NGINX Status
  
    [Service]
    ExecStart=/usr/local/bin/nginx_status_check.sh
    EOU
    mode '0644'
    owner 'root'
    group 'root'
end
  
  # Create the systemd timer file
file '/etc/systemd/system/nginx_status_check.timer' do
    content <<-EOU
    [Unit]
    Description=Run nginx_status_check every hour
  
    [Timer]
    OnBootSec=10min
    OnUnitActiveSec=1h
  
    [Install]
    WantedBy=timers.target
    EOU
    mode '0644'
    owner 'root'
    group 'root'
end
  
  # Enable and start the systemd timer for nginx status check
service 'nginx_status_check.timer' do
    action [:enable, :start]
    only_if { ::File.exist?('/etc/systemd/system/nginx_status_check.timer') }
end
