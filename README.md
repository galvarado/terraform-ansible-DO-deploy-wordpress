# terraform-ansible-DO-deploy-wordpress

Automate the provisioning of infrastructure resources in Digital Ocean by using Terraform and the deployment of WordPress on those resources with Ansible.


## How to use

### Clone this repository

```

git clone git@github.com:galvarado/terraform-ansible-DO-deploy-wordpress.git
```


### Digital Ocean Token

To provision the infrastructure where the blog with Wordpress will be installed, it is necessary to have an account in Digital Ocean. Once we have the account, we must give Terraform access so that it can create the infrastructure for us.

For this it is necessary to generate a token, go to the page: https://cloud.digitalocean.com/account/api/tokens and create it.


### Create variables file

In the root path of the code, create a file named terraform.tfvars and place the following variables:

```

do_token: must have the token created in the previous step.
ssh_key_private: the path of the private key that will be used to access the server in Digital Ocean.
droplet_ssh_key_id: The id of the key in DigitalOcean that will be used to connect to the virtual machine
droplet_name: The name of the droplet in DigitalOcean
droplet_size: The size of the droplet to use
droplet_region: The region where the droplet will be deployed
```



To obtain the values of the region, the ssh key, the name of the image and the size of the virtual machine, installed the Digital Ocean command-line client.


To list all available ssh keys in the account:
```

$ doctl  -t [TOKEN] compute ssh-key list
```


To list all OS available:
```

$ doctl  -t [TOKEN] compute  image list --public
```


To list all OS available:
```

$ doctl  -t [TOKEN] compute  region list
```


To list all sizes available:
```

$ doctl  -t [TOKEN] compute  size list
```


**terraform.tfvars**
```

do_token = "123bc07c22f942ceccbdc010ff18025db0199bd6f916953c90b974d95caa7439"
ssh_key_private = "~/.ssh/id_rsa"
droplet_ssh_key_id = "2632045"
droplet_name = "MyBlog"
droplet_size = "s-1vcpu-1gb"
droplet_region = "nyc1"
```



Note: both the key path and the id of the digital ocean key must refer to the same key.

### Wordpress configuration (optional)
Although it is not necessary to execute the code, you can optionally change the values defined for the MySQL database to be used with wordpress as well as the configuration values of wordpress:

playbooks/roles/mysql/defaults/main.yml contains the following variables that can be modified:

```

---
# defaults file for mysql
wp_mysql_db: wordpress
wp_mysql_user: wordpress
wp_mysql_password: randompassword
```


If these values are not modified, they will be the data that will be used to create the wordpress database in MySQL and will also be the values that will be used in the wp_config.php file while ansible configures the site.

playbooks/roles/wordpress/defaults/main.yml contains the following variables that can be modified:


```
---
# defaults file for wordpress
wp_site_title: New blog
wp_site_user: superadmin
wp_site_password: strongpasshere
wp_site_email: some_email@example.com
```


If these values are not modified, they will be the data you will need to enter Wordpress as an administrator user.

### Ejecutar terraform


To deploy the blog we just have to execute the following commands:
```

$ terraform plan
$ terraform apply
```

Once the playbooks are finished, we can access our blog in the address / IP that is shown as ansible output and connect with the credentials in playbooks/roles/wordpress/defaults/main.yml.

##Summary


This is the summary of the tasks performed (25):

**Terraform**

Create Digitral Ocean droplet

**Ansible**

Install python 2
Update yum cache
Download and install MySQL Community Repo
Install MySQL Server
Install remi repo
Enable remi-php72
Update yum
Install Apache and PHP
Install php extensions
Start MySQL Server and enable it
Remove Test database if it exists
Remove All Anonymous User Accounts
Create mysql database
Create mysql user
Download WordPress
Extract WordPress
Update default Apache site
Update default document root
Copy sample config file
Update WordPress config file
Download wp-cli
Test if wp-cli is correctly installed
Finish wordpress setup via wp-cli
Restart apache