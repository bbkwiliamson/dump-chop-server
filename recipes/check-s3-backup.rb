template '/usr/local/bin/s3_backup.sh' do
    source 's3_backup.sh.erb'
    mode '0755'
    variables(
      s3_bucket: node['backup']['s3_bucket'],
      backup_dir: node['backup']['backup_dir'],
      external_disk_path: node['backup']['external_disk_path'],
      telegram_bot_token: node['backup_monitor']['telegram_bot_token'],
      telegram_chat_id: node['backup_monitor']['telegram_chat_id'],
      s3_bucket_arn: node['backup']['s3_arn'],
      hostname: node['hostname']
    )
end

# Create the systemd service file
file '/etc/systemd/system/s3_backup.service' do
    content <<-EOU
    [Unit]
    Description=Backup files and upload to S3
  
    [Service]
    Type=oneshot
    ExecStart=/usr/local/bin/s3_backup.sh
    EOU
    mode '0644'
    owner 'root'
    group 'root'
end
  
  # Create the systemd timer file (runs every 2 weeks)
file '/etc/systemd/system/s3_backup.timer' do
    content <<-EOU
    [Unit]
    Description=Run backup every 2 weeks
  
    [Timer]
    OnCalendar=*-*-01,15 02:00:00
    Persistent=true
  
    [Install]
    WantedBy=timers.target
    EOU
    mode '0644'
    owner 'root'
    group 'root'
end
  
  # Reload systemd, enable and start the timer
execute 'reload_systemd' do
    command 'systemctl daemon-reload'
end
  
service 's3_backup.timer' do
    action [:enable, :start]
end
