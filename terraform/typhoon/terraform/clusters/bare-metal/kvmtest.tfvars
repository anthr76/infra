cluster_name = "k8skvm"
matchbox_http_endpoint = "http://nwk1-app-1.rabbito.tech:8080"
controllers = [
    {name = "node1", mac = "52:54:00:00:00:a1", domain = "k8s-node-1.k8skvm.rabbito.tech", os_channel = "flatcar-stable", os_version = "2605.7.0"},
]
workers = [
  { name = "node2", mac = "52:54:00:00:00:a2", domain = "k8s-node-2.k8skvm.rabbito.tech", os_channel = "flatcar-stable", os_version = "2605.7.0"},
  { name = "node3", mac = "52:54:00:00:00:a3", domain = "k8s-node-3.k8skvm.rabbito.tech", os_channel = "flatcar-stable", os_version = "2605.7.0"},
  { name = "node4", mac = "52:54:00:00:00:a4", domain = "k8s-node-4.k8skvm.rabbito.tech", os_channel = "flatcar-alpha", os_version = "2671.0.0"}
]
k8s_domain_name = "k8skvm.rabbito.tech"
ssh_authorized_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDIWVikHZuTKOhKig6cQwxkoT4DyzLiXgVbySjX4Br9Yxn6gVPHsIBJZT/KH8bfwxVbompToV3sdnLsQSl03kdfkjLFiryeCJ1PvKSY/STfxg3LVcsMX9rrgLriYCxZVvrn5QBBuKmQkpK2KqSiJQKzpWZsi3dKdVsq5D6/pdU62pXOUs1nNogqJHQYRsBzTpgb/iYrpN2JARPBjU3vER3eqDnhUbi9VgsTtcFLuPJpH+o5JMr1PhtvAdXlBPDsbpp0W9qpuUZvdKn/OBEN19NxWTPu+A71fpDN2z8ebJqfqeHxx3vOpZJtTgYwNDlc2pVuZ2be3s1f5CKdwyVxIHAtshTsJF0VPehULQB4RXwNV2sVUr4rox2Fxr8uWRyz4/yudVEl1s/mXeHvK21NPBedHagSu+RSPXMl/5O1tUC0NQ7ZDiJNNYL6BpblSIbFkC/mZQQuX8AuKKzBDyezNJHtiia3wcv32TmfeGb54IgeaLgpCxpo/IDYrCIYvl4sVaqKH1EfbMIB5UpWIW3nAGJfOse8rhn8BjiwhjKfShks8euH5wZkqhiddK2NR43tShxqJvik4t03KVfwg/JqqARJDTioWagSaHcuIutWR7AuNWGQs/8fIJYd4NawbKoEyqEoiaqkwr3fxtijI2i1RpArFDflHIUfFw2nHF/pQ/FDLw== hello@anthonyrabbito.com"
networking = "calico"
install_disk = "/dev/vda"
kernel_args = [
  "usb-storage.quirks=152d:0578:u"
]
cached_install = true
enable_reporting = true