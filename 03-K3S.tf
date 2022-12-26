# Creating k3s master droplet
resource "digitalocean_droplet" "k3s-master" {

  depends_on = [
    digitalocean_database_db.k3s-db
  ]
  image     = "ubuntu-20-04-x64"
  name      = "k3s-master-1"
  region    = "blr1"
  size      = "s-1vcpu-1gb"
  ssh_keys  = ["d7:dd:f0:03:d5:8b:36:3e:c9:a3:ee:e5:31:75:15:52"]
}


# Install k3s 
resource "null_resource" "k3s-install" {

  depends_on = [
    digitalocean_droplet.k3s-master
  ]

  connection {
    host        = digitalocean_droplet.k3s-master.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file("./id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "curl -sfL https://get.k3s.io | sh -s - server - datastore-endpoint='mysql://k3s:$'{digitalocean_database_user.sql_user.password}'@tcp($'{digitalocean_database_cluster.my_sql.host}':25060)/k3s'",
      "cat /var/lib/rancher/k3s/server/node-token",
      
    ]
  }
}


# Creating droplet for worker nodes
resource "digitalocean_droplet" "worker-1" {

  depends_on = [
    digitalocean_droplet.k3s-master, null_resource.k3s-install
  ]

  image  = "ubuntu-20-04-x64"
  name   = "worker-1"
  region = "blr1"
  size   = "s-1vcpu-1gb"

  ssh_keys = [
    "d7:dd:f0:03:d5:8b:36:3e:c9:a3:ee:e5:31:75:15:52"
  ]
}


# Creating droplet for worker nodes
resource "digitalocean_droplet" "worker-2" {

  depends_on = [
    digitalocean_droplet.k3s-master, null_resource.k3s-install
  ]

  image  = "ubuntu-20-04-x64"
  name   = "worker-2"
  region = "blr1"
  size   = "s-1vcpu-1gb"

  ssh_keys = [
    "d7:dd:f0:03:d5:8b:36:3e:c9:a3:ee:e5:31:75:15:52"
  ]
 
}


# Install k3s on worker and add the node to the master node by using the token
resource "null_resource" "worker-1" {

  depends_on = [
    digitalocean_droplet.worker-1 
  ]

  connection {
    host        = digitalocean_droplet.worker-1.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file("./id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "wget https://github.com/k3s-io/k3s/releases/download/v1.23.5%2Bk3s1/k3s",
      "chmod +x k3s",
       "curl -sfL https://get.k3s.io | K3S_URL=https://${digitalocean_droplet.k3s-master.ipv4_address}:6443 K3S_TOKEN=K1018e095eb496cc95ec273ef3ccd08efb8ec37b64f47bd68c2fb50495c9b2cee65::server:a278b1827f63d4540077af1ec7a68881 sh - " ,
   
    ]
  }

}


# Install k3s on worker and add the node to the master node by using the token
resource "null_resource" "worker-2" {

  depends_on = [
    digitalocean_droplet.worker-2, null_resource.worker-1
  ]

  connection {
    host        = digitalocean_droplet.worker-2.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file("./id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "wget https://github.com/k3s-io/k3s/releases/download/v1.23.5%2Bk3s1/k3s",
      "chmod +x k3s",
      "curl -sfL https://get.k3s.io | K3S_URL=https://${digitalocean_droplet.k3s-master.ipv4_address}:6443 K3S_TOKEN=K1018e095eb496cc95ec273ef3ccd08efb8ec37b64f47bd68c2fb50495c9b2cee65::server:a278b1827f63d4540077af1ec7a68881 sh - "
    ]
  }

}

