# dump-chop-server

when you want to make the changes that made to your chef server:
          chef update Policyfile.rb (click enter)   
                   the command will generate a Policy.lock.json file
          then: chef push sit Policy.lock.json (click enter)

          obviously things such as the host servers must be specified in the metadata.rb file and policyfile.rb file
          this cookbook is mainly about setting up a server with required packages and meeting specified standards and also attaching external disks and implementing certain monitoring on the vm
