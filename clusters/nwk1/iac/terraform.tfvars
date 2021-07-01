matchbox_http_endpoint = "matchbox.nyc1.rabbito.tech"
cluster_name = "nwk1"
aarch64_masters = [
{name="master-1",
mac="dc:a6:32:03:59:4d",
domain="master-1.nwk1.rabbito.tech",
},
{
name="master-2",
mac="dc:a6:32:03:cf:77",
domain="master-2.nwk1.rabbito.tech"},
{
name="master-3",
mac="dc:a6:32:03:d2:ff",
domain="master-3.nwk1.rabbito.tech"},
]
aarch64_workers = [
{name="worker-4",
mac="dc:a6:32:cc:34:a6",
domain="worker-4.nwk1.rabbito.tech",
},
{
name="worker-5",
mac="dc:a6:32:46:d6:3c",
domain="worker-5.nwk1.rabbito.tech",
},
{
name="worker-6",
mac="dc:a6:32:39:5d:69",
domain="worker-6.nwk1.rabbito.tech",
},
{
name="worker-7",
mac="dc:a6:32:39:76:89",
domain="worker-7.nwk1.rabbito.tech",
},
]
amd64_workers = [
{name="worker-1",
mac="a0:36:9f:ff:ff:ff",
domain="worker-1.nwk1.rabbito.tech",
},
{
name="worker-2",
mac="90:e2:ba:8c:70:3a",
domain="worker-2.nwk1.rabbito.tech"},
{
name="worker-3",
mac="90:e2:ba:8c:74:98",
domain="worker-3.nwk1.rabbito.tech"},
]
