# Install EPEL repository      for rhel8+ no need to directly install epel
# package 'epel-release' do
#     action :install
# end
  
  # Install Nginx
package 'nginx' do
    action :install
end
  
  # Ensure Nginx service is enabled and started
service 'nginx' do
    action [:enable, :start]
end
