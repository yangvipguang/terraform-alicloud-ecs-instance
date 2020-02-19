resource "alicloud_disk" "dataspace" {
  availability_zone = "cn-beijing-a"
  size              = "100"

  tags = {
    Name = "dataspace"
  }
}
resource "alicloud_instance" "MMT-Aliyun-ECS" {
    security_groups = ["sg-bp194e7bypr512mjqvuw"]
    availability_zone = "cn-hangzhou-b"

    #count = 3
    #host_name = "Web.${count.index}"
    count = length(var.host_name)     #count = length(var.subnet_ids)
    host_name = var.host_name[count.index]   ## var.subnet_ids[count.index]
    image_id             = "ubuntu_18_04_64_20G_alibase_20190624.vhd"
    instance_type        = "ecs.sn1ne.large"
    instance_name        = "MMT-Test-terraform"
    internet_charge_type = "PayByBandwidth"
    internet_max_bandwidth_out = 100  ##分配公网IP
    system_disk_category = "cloud_efficiency"
    system_disk_size = 80
    key_name = "MMT-Admin"
    vswitch_id = "vsw-bp1b8y9u9uw4231ud449b"
    tags = {
            from = "terraform"
            env = "dev-mmt"
    }
}


resource "alicloud_disk_attachment" "ecs_disk_att" {
  disk_id     = "${alicloud_disk.dataspace.id}"
  instance_id = "${alicloud_instance.MMT-Aliyun-ECS.id}"
}
