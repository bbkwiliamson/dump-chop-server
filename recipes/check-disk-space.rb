
template '/usr/local/bin/check_disk_space.sh' do
    source 'check_disk_space.sh.erb'
    mode '0755'
    variables(
      telegram_bot_token: node['backup_monitor']['telegram_bot_token'],
      telegram_chat_id: node['backup_monitor']['telegram_chat_id'],
    )
end

file '/etc/systemd/system/check_disk_space.service' do
    content <<-EOU
    [Unit]
    Description=Check and extend /var disk space if needed
  
    [Service]
    ExecStart=/usr/local/bin/check_disk_space.sh
    User=root
    Type=oneshot
    EOU
    mode '0644'
end

file '/etc/systemd/system/check_disk_space.timer' do
    content <<-EOU
    [Unit]
    Description=Run disk space check every hour
  
    [Timer]
    OnCalendar=hourly
    Persistent=true
  
    [Install]
    WantedBy=timers.target
    EOU
    mode '0644'
end

execute 'reload_systemd' do
    command 'systemctl daemon-reload'
    action :run
end
  
service 'check_disk_space.timer' do
    action [:enable, :start]
end

  
  
