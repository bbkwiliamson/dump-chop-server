default['sbg-centrify']['zone'] = 'SBOG-PROD' if node.chef_environment.include?('-PROD')


default['backup_monitor']['telegram_bot_token'] = '7748969303:AAFxEf75pS3VxboKU0mNtm3xszbwsIGvhfs'
default['backup_monitor']['telegram_chat_id'] = '-1002346757931'
default['backup']['s3_bucket'] = 'dump-chop-repo-573185292006'
default['backup']['s3_arn'] = 'arn:aws:s3:::dump-chop-repo-573185292006'

if node['hostname'] == 'dchop231'
  default['backup']['external_disk_path'] = '/mnt/external-disk' #external disk mounted on the vm
  default['backup']['backup_dir'] = '/mnt/external-disk/var/www/dump'
elsif node['hostname'] == 'psbgdump1v'
  default['backup']['external_disk_path'] = '/mnt/external-disk2' #external disk mounted on the vm
  default['backup']['backup_dir'] = '/mnt/external-disk2/var/www/dump'
elsif node['hostname'] == 'rsbgdump1v'
  default['backup']['external_disk_path'] = '/mnt/external-disk3' #external disk mounted on the vm
  default['backup']['backup_dir'] = '/mnt/external-disk3/var/www/dump'
else
  default['backup']['external_disk_path'] = '/mnt/external-disk' #external disk mounted on the vm
  default['backup']['backup_dir'] = '/mnt/external-disk/var/www/dump' 
end




default['governance_config'] = {
  "billing": {
  "Billing Application Name": 'Digital platforms',
  "Billing Foreign Key": 'TC00082',
  "Business Unit": 'PPBSA DIGITAL PLATFORMS',
  },
  "application": {
    "Application Name": 'Dump-Chop repo',
    "Description": 'Infrastructure Dump-chop Repo',
    "System Owner": 'marlyse.debruin@bbkgroup.co.za',
    "Technical Owner": 'sbgdevops@bbkgroup.co.za',
    "Team": 'Infrastructure and Cloud Enablement',
    "Environment": 'Production',
    "Host Platform": 'VMWare',
    "Hostname": node['hostname'],
    "IP Address": node['ipaddress'],
    "FQDN": node['fqdn'],
  },
}

