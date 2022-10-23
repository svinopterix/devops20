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
        "web" = [2, 4]
        "db" = [4, 8]
    }
}