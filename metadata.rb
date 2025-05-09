name 'dump-chop-server'
maintainer 'SGB DEVOPS'
maintainer_email 'sbgdevops@bbkgroup.co.za'
license 'All Rights Reserved'
description 'Installs/Configures dump-chop-vm'
# long_description 'Installs/Configures dump-chop-server'
version '2.6.6'
chef_version '>= 16.0' if respond_to?(:chef_version)

depends 'chop-base-server'
supports 'redhat'

depends 'sbgstore-base'
depends 'dnsmasq-local'
depends 'edr-cyberreason'
depends 'qradar'
depends 'tetration'
depends 'sbg-devops'
depends 'sb_beats'
depends 'lev2arg'
depends 'audit'
depends 'sbg-nscd'
depends 'sbg-centrify'
# depends 'rccnet_reset'
# depends 'sbg-governance'
depends 'cloudamize-agent'
depends 'sbg-infrabuddy-2'
depends 'rubygems-bubblewrap'
depends 'mde'
# depends 'ark'
# depends 'appdynamics-agents'

