# Deploy the backup check script
template '/usr/local/bin/check-backup.sh' do
    source 'check-backup.sh.erb'
    mode '0755'
    owner 'root'
    group 'root'
end
  
  # Create the systemd service file
file '/etc/systemd/system/check-backup.service' do
    content <<-EOU
    [Unit]
    Description=Check Backup Files
  
    [Service]
    ExecStart=/usr/local/bin/check-backup.sh
    StandardOutput=journal
    StandardError=journal
    EOU
    mode '0644'
    owner 'root'
    group 'root'
end
  
  # Create the systemd timer file
file '/etc/systemd/system/check-backup.timer' do
    content <<-EOU
    [Unit]
    Description=Run Backup Check Every Hour
  
    [Timer]
    OnBootSec=10min
    OnUnitActiveSec=1h
    Persistent=true
  
    [Install]
    WantedBy=timers.target
    EOU
    mode '0644'
    owner 'root'
    group 'root'
end
  
  # Reload systemd to apply changes
execute 'reload_systemd' do
    command 'systemctl daemon-reload'
    action :run
end
  
  # Enable and start the timer
service 'check-backup.timer' do
    action [:enable, :start]
end
