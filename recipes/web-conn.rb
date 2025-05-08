
external_disk_path = node['backup']['external_disk_path']

package 'screen' do
    action :install
end

package 'rsync' do
  action :install
end

package 'unzip' do
    action :install
end

# Ensure /var/www and /var/www/dump directories exist
directory '/var/www' do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
end

directory '/var/www/dump' do
    owner 'nginx'
    group 'nginx'
    mode '0755'
    recursive true
    action :create
end
  
directory "#{external_disk_path}/var/www/dump" do
    owner 'nginx'
    group 'nginx'
    mode '0755'
    recursive true
    action :create
end
