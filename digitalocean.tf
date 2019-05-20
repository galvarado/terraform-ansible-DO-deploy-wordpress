variable "do_token" {}
variable "ssh_key_private" {}
variable "droplet_ssh_key_id" {}
variable "droplet_name" {}
variable "droplet_size" {}
variable "droplet_region" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
    token = "${var.do_token}"
}

# Create a web server
resource "digitalocean_droplet" "myblog" {
    image  = "centos-7-x64"
    name   = "${var.droplet_name}"
    region = "${var.droplet_region}"
    size   = "${var.droplet_size}"
    monitoring = "true"
    ssh_keys = ["${var.droplet_ssh_key_id}"]

    # Install python on the droplet using remote-exec to execute ansible playbooks to configure the services
    provisioner "remote-exec" {
        inline = [
          "yum install python -y",
        ]

         connection {
            host        = "${self.ipv4_address}"
            type        = "ssh"
            user        = "root"
            private_key = "${file("${var.ssh_key_private}")}"
        }
    }

    # Execute ansible playbooks using local-exec 
    provisioner "local-exec" {
        environment {
            PUBLIC_IP                 = "${self.ipv4_address}"
            PRIVATE_IP                = "${self.ipv4_address_private}"
            ANSIBLE_HOST_KEY_CHECKING = "False" 
        }

        working_dir = "playbooks/"
        command     = "ansible-playbook -u root --private-key ${var.ssh_key_private} -i ${self.ipv4_address}, wordpress_playbook.yml"
    }
}