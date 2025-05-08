

include_recipe '::mount-disk'
include_recipe '::nginx'
include_recipe '::web-conn'
include_recipe '::aws-cli'
include_recipe '::check-disk-space'
include_recipe '::check_backup'
include_recipe '::nginx-conf'
include_recipe '::check-nginx-status'
include_recipe '::create-s3-backup'

execute 'reload_systemd' do
    command 'systemctl daemon-reload'
end
  
service 's3_backup.timer' do
    action [:enable, :start]
end

service 'nginx_status_check.timer' do
    action [:enable, :start]
    only_if { ::File.exist?('/etc/systemd/system/nginx_status_check.timer') }
end

service 'check_disk_space.timer' do
    action [:enable, :start]
end

service 'check-backup.timer' do
    action [:enable, :start]
end
