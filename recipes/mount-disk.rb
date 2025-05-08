# Define the external disk path and mount point based on the node's hostname
external_disk_path = node['backup']['external_disk_path']

# Unmount if mounted
execute 'unmount_sdb' do
  command "umount #{external_disk_path}"
  only_if "mount | grep '#{external_disk_path}'"
  action :run
end

# Run fsck only if needed
execute 'fsck_check' do
  command "fsck -y /dev/sdb"
  returns [0, 1, 2, 4] # Allow fsck to return success and repaired states
  only_if { 
    ::File.exist?('/dev/sdb') && 
    `mount | grep /dev/sdb`.empty? && 
    system('dumpe2fs /dev/sdb | grep -q "Filesystem state: not clean"') 
  }
end

# Create the mount point
directory external_disk_path do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Mount /dev/sdb to the appropriate external disk path
mount external_disk_path do
  device '/dev/sdb'
  fstype 'ext4' # filesystem type (e.g., xfs, ext3, etc.)
  options 'defaults'
  action [:mount, :enable] # Mounts now and ensures it persists on reboot
end

# Check disk usage and existance
execute 'check_disk_usage' do
    command 'lsblk'
    command 'df -h'
    live_stream true # Prints output to the Chef run logs
end


# Get the available space and usage percentage for /var
ruby_block 'check_var_disk_space' do
    block do
      require 'mixlib/shellout'
      
      # Get available space in GB
      free_space_cmd = Mixlib::ShellOut.new("df -BG --output=avail /var | tail -1 | tr -d 'G '")
      free_space_cmd.run_command
      free_space = free_space_cmd.stdout.strip.to_i
      
      # Get usage percentage
      usage_cmd = Mixlib::ShellOut.new("df -h --output=pcent /var | tail -1 | tr -d '% '")
      usage_cmd.run_command
      usage = usage_cmd.stdout.strip.to_i
  
      # Check if conditions are met
      if free_space < 10
        node.run_state['resize_var'] = { 'resize' => true, 'size' => 10 }
      elsif usage >= 70
        node.run_state['resize_var'] = { 'resize' => true, 'size' => 20 }
      elsif usage >= 50 && usage < 70
        node.run_state['resize_var'] = { 'resize' => true, 'size' => 10 }
      else
        node.run_state['resize_var'] = { 'resize' => false }
      end
    end
end
  
  # Extend Logical Volume only if conditions are met
# execute 'extend_logical_volume' do
#     command lazy { "lvextend -An -L +#{node.run_state['resize_var']['size']}GB --resizefs /dev/mapper/systemvg-varlv" }
#     user 'root'
#     live_stream true
#     action :run
#     only_if { node.run_state['resize_var']['resize'] }
# end
  
#   # Resize XFS Filesystem only if conditions are met
# execute 'resize_xfs_filesystem' do
#     command 'xfs_growfs /dev/mapper/systemvg-varlv'
#     user 'root'
#     live_stream true
#     action :run
#     only_if { node.run_state['resize_var']['resize'] }
# end


# execute 'sync_files_with_rsync' do
#     command 'rsync -av --progress /mnt/external-disk/ /var/www/dump/'
#     user 'root' 
#     live_stream true # Show progress in Chef logs
#     action :run
# end
  
