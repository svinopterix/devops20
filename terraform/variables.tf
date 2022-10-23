locals {
    cores_map = {
        stage = 2
        prod = 4
    }

    memory_map = {
        stage = 2
        prod = 4
    }

    count_map = {
        stage = 1
        prod = 2
    }

    vm_2_instances = {
        prod = {
            "web1" = [2, 4]
            "web2" = [2, 4]
            "db" = [4, 8]
        }

        stage = {
            "web" = [2, 2]
            "db" = [2, 4]
        }
    }
}