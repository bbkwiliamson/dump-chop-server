name 'dump-chop-server'

override['filebeat']['config'] = {
  "filebeat": {
    "inputs": [
      {
        "type": 'log',
        "enabled": true,
        "paths": [
          '/var/log/sudo.log',
          '/var/log/secure',
          '/var/log/messages',
          '/var/log/localbuffer',
          '/var/log/lev2r/devopadm-.pts-*.*.log',
          '/var/log/lastlog',
          '/var/log/dmesg',
          '/var/log/cron',
          '/var/log/audit/audit.log',
          '/var/log/anaconda/anaconda.log',
          '/var/log/anaconda/ifcfg.log',
          '/var/log/anaconda/journal.log',
          '/var/log/anaconda/syslog',
        ],
        "encoding": 'plain',
      },
    ],
  },
  "name": 'sbg_devops',
  "tags": %w(
    sbg_devops
    echelon
  ),
  "output": {
    "kafka": {
      "enable": true,
      "hosts": [
        'plogcr1p.bbkgroup.co.za:9092',
        'plogcr2p.bbkgroup.co.za:9092',
        'plogcr3p.bbkgroup.co.za:9092',
      ],
      "topic": 'lm_file_digitalchannels',
      "version": '2.0.0',
      "username": 'lm_file_digitalchannels',
      "password": 's9Hkyu5rh9CzpqjeBe4epUZ18',
      "ssl": {
        "certificate_authorities": [
          '/etc/ssl/certs/sbsa-bundle.pem',
        ],
        "enabled": true,
      },
    },
  },
}

# run_list: chef-client will run these recipes in the order specified.
run_list 'dump-chop-server::default'

cookbook 'dump-chop-server', path: '.'

include_policy 'chop-base-server', git: 'ssh://git@tools.bbkgroup.co.za:7999/sc/sbg-policies.git', path: 'base/chop-base-server/SBG-PROD.lock.json'
