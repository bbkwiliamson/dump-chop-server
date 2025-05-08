
external_disk_path = node['backup']['external_disk_path']
backup_dir = node['backup']['backup_dir']

directory "#{external_disk_path}/var/www/dump" do
    owner 'nginx'
    group 'nginx'
    mode '0755'
    action :create
end

directory '/var/www/dump' do
    owner 'nginx'
    group 'nginx'
    mode '0755'
    action :create
end

directory "#{backup_dir}" do
  owner 'nginx'
  group 'nginx'
  mode '0755'
  action :create
end

template '/etc/nginx/conf.d/dump.conf' do
    source 'dump.conf.erb'
    mode '0644'
    variables(
      domain_or_ip: node['fqdn'],
      ipaddress: node['ipaddress'],
      external_disk: node['backup']['external_disk_path']
    )
    notifies :reload, 'service[nginx]', :immediately
end
  
service 'nginx' do
    action :nothing  # This will be triggered by the notification
end

