resource "digitalocean_database_cluster" "my_sql" {

  name       = "mysqldb"
  engine     = "mysql"
  size       = "db-s-1vcpu-1gb"
  region     = "fra1"
  node_count = 1
  version    = "8"
}

resource "digitalocean_database_db" "k3s-db" {
  cluster_id = digitalocean_database_cluster.my_sql.id
  name       = "k3s"
}

resource "digitalocean_database_user" "sql_user" {
  cluster_id = digitalocean_database_cluster.my_sql.id
  name       = "k3s"
}




