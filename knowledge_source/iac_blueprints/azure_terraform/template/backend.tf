terraform {
    backend "azurerm" {
        resource_group_name = "test-rg-01"
        storage_account_name = "ashuttestst01"
        container_name = "tfstate"
        key = "mgmt-network.tfstate"
       // access_key = "7M/tgBG19mU2EdJ5BHVmyB14XRdCjG37YC63RmIyzvXf/d9TG1QOlQymztMWETmxNRUM5uucmd7J2dpPjXhwqA=="
    }
}