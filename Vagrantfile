Vagrant.configure("2") do |config|
  
    config.vm.box_check_update = false
	
	config.vm.define "backup" do |backup|
		backup.vm.box = "centos/7"
		backup.vm.communicator = "ssh"
		backup.vm.hostname = "backup"
		backup.vm.network "private_network", ip: "192.168.56.160"
		#backup.vm.network "forwarded_port", guest: 80, host: 8080

		backup.vm.provider "virtualbox" do |vb|

			#----------------------------------------------- ДИСК --------------------------------------------------------------------------------
			
			file_to_disk = './large_disk.vdi'
			disk_size = 3072		
			needsController =  false
						
			unless File.exist?(file_to_disk)
				vb.customize ['createhd', '--filename', file_to_disk, '--variant', 'Fixed', '--size', disk_size]
				needsController =  true
			end
			
			if needsController == true
				vb.customize ["storagectl", :id, "--name", "SATA", "--add", "sata" ]
				vb.customize ['storageattach', :id, '--storagectl', 'SATA', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
			end
			
			#-------------------------------------------------------------------------------------------------------------------------------------

			vb.cpus = 1
			vb.gui = false
			vb.memory = "1024"
		end
		
		backup.vm.provision "shell", path: "backup.sh"
		
	end
	
	config.vm.define "client" do |client|
		client.vm.box = "centos/7"
		client.vm.communicator = "ssh"
		client.vm.hostname = "client"
		client.vm.network "private_network", ip: "192.168.56.150"
		#client.vm.network "forwarded_port", guest: 80, host: 8080

		client.vm.provider "virtualbox" do |vb|
			vb.cpus = 1
			vb.gui = false
			vb.memory = "1024"
		end
		
		client.vm.provision "shell", path: "client.sh"
		
	end
	
end
