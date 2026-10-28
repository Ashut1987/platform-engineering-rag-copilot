variable "resource_group_name" {
    description = "Provide rg name without prefix"
}
variable "resource_location" {
    description = "Provide rg location"
}
variable "sqldatabase_name" {
    
    description = "Provide sql database name"
}
variable "sql_server_name" {
    
    description = "Provide sql server name"
}
variable "database_edition" {
    
    description = "The edition of DB - Basic, Standard, Premium or DataWarehouse are allowed values"
}
variable "requested_service_objective_name" {
    
    description = "The service tier S0, S1, S2, S3, P1, P2, P4, P6, P11 and ElasticPool"
}
