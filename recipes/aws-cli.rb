require 'json'
require 'mixlib/shellout'
require 'chef-vault'

# Download the AWS CLI installer
remote_file '/tmp/awscliv2.zip' do
    source 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip'
    mode '0755'
    action :create
    not_if 'which aws'
end
  
# Unzip the AWS CLI installer
execute 'unzip_awscli' do
  command 'unzip -o /tmp/awscliv2.zip -d /tmp/'
  action :run
  not_if 'command -v aws'
end

# Run the AWS CLI install script (with update)
execute 'install_awscli' do
  command '/tmp/aws/install --update'
  not_if { ::File.exist?('/usr/local/aws-cli/v2/current') }
  action :run
end

execute 'set_temporary_path' do
  command "export PATH=/usr/local/aws-cli/v2/current/bin:$PATH"
  action :run
end

file '/etc/profile.d/awscli.sh' do
  content 'export PATH=/usr/local/aws-cli/v2/current/bin:$PATH'
  mode '0755'
  owner 'root'
  group 'root'
end

execute 'apply_path_changes' do
  command "echo 'export PATH=/usr/local/aws-cli/v2/current/bin:$PATH'"
  action :run
end

# Clean up installation files
file '/tmp/awscliv2.zip' do
  action :delete
end

directory '/tmp/aws' do
  recursive true
  action :delete
end

directory '/root/.aws' do
    recursive true
    mode '0755'
    action :create
end
  
template '/root/.aws/config' do
    source 'config.erb'
    mode '0755'
end
  
template '/root/.aws/credentials' do
    source 'aws-creds.erb'
    variables({
      aws_access_key_id: ChefVault::Item.load('secrets', 'aws-creds')['aws_access_key_id'],
      aws_secret_access_key: ChefVault::Item.load('secrets', 'aws-creds')['aws_secret_access_key']
    })
    mode '0755'
end
