output "mysql_host" {
  value = digitalocean_database_cluster.my_sql.host
}

output "master_ipv4address" {
  value = digitalocean_droplet.k3s-master.ipv4_address
}

output "worker-1_ipv4address" {
  value = digitalocean_droplet.worker-1.ipv4_address
}

output "worker-2_ipv4address" {
  value = digitalocean_droplet.worker-2.ipv4_address
}
 