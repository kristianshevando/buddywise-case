SUBSCRIPTION_ID   = "<placeholder>"
SPN_CLIENT_ID     = "<placeholder>"
SPN_CLIENT_SECRET = "<placeholder>"
TENANT_ID         = "<placeholder>"

INFRASTRUCTURE_NAME           = "bdws"
SUFFIX                        = "core"
PREFIX                        = "prd"
AUTOMATED_DESTROY             = false
TERRAFORM_CODE_PACKAGE_NUMBER = "1.0.0:somecommithash"
LOCATION                      = "westeurope"
infrastructure_code_version   = "1.0.0"
# !!! All parameters above must be set on deployment agent site as env variables 

azurerm_k8s_clusters = [
  {
    azure_k8s_cluster_index                                  = "01"
    azure_k8s_cluster_location                               = "default"
    azure_k8s_vnet_address_space                             = ["10.0.16.0/22"]
    azure_k8s_cluster_availability_zones                     = ["1","2","3"]
    azure_k8s_service_vnet_address_space                     = ["10.0.15.0/24"]
    azure_vault_sa_backup_enabled                            = true
    azure_core_storage_account_type                          = "ZRS"
    azure_core_storage_account_tier                          = "Standard"
    azure_core_storage_account_access_tier                   = "Hot"
    azure_core_storage_account_kind                          = "StorageV2"
    azure_sql_database_maximum_size_bytes                    = "2147483648"
    azure_k8s_cluster_version                                = "1.30.0"
    azure_k8s_cluster_sku_tier                               = "Standard" ### If an SLA is required, use the "Paid" tier sku.
    azure_k8s_cluster_azure_policy_enabled                   = false
    azure_k8s_cluster_local_account_disabled                 = false
    azure_k8s_cluster_role_based_access_control_enabled      = true
    azure_k8s_cluster_oidc_issuer_enabled                    = true
    azure_k8s_cluster_workload_identity_enabled              = true
    azure_k8s_cluster_admin_group_object_ids                 = []
    azure_k8s_cluster_azure_rbac_enabled                     = false
    azure_k8s_cluster_system_storage_type                    = "Premium_ZRS"
    azure_k8s_private_cluster_enabled                        = true
    azure_k8s_cluster_admin_username                         = "core-admin"
    azure_k8s_cluster_nginx_ingress_fqdn  	                 = "test.buddywise.com"     ### NOTE: each domain label must be at least 3 characters long. For test purposes it is necessary to use fqdn "*.qa.buddywise-cloud.com" with appropriate certificate data.
    azure_k8s_cluster_nginx_ingress_pls_enabled              = true                   ### should be true if azure_k8s_cluster_nginx_ingress_access_mode = "private-s2s" || "private-afd"
    azure_k8s_cluster_nginx_ingress_access_mode              = "public"          ### possible values: "private-afd" (for public environments with AFD (default)), "private-s2s" (for private environments with VPN), "public" (for public environments without AFD)

    ### IMPORTANT: "private-afd" is only supported in the following regions: brazilsouth, canadacentral, centralus, eastus, eastus2, southcentralus, westus3, francecentral, germanywestcentral, northeurope, norwayeast, uksouth, westeurope, swedencentral, southafricanorth, australiaeast, centralindia, japaneast, koreacentral, eastasia.
    ### https://learn.microsoft.com/en-us/azure/frontdoor/private-link#region-availability

    azure_k8s_cluster_nginx_ingress_public_dns_creation_mode = "auto"                 ### Possible values auto, manual. Auto is applicable only for buddywise-cloud.com and buddywiseqa.com domains. The necessary credentials shoud be provided: using appropriate variable group for buddywiseqa.com DNS records management or using CloudFlare API token for buddywise-cloud.com DNS records management.
    azure_k8s_ingress_public_ip                              = ""                     ### optional parameter if azure_k8s_cluster_nginx_ingress_access_mode == "public"
    azure_k8s_ingress_public_ip_resource_group_id            = ""                     ### optional parameter if azure_k8s_cluster_nginx_ingress_access_mode == "public"
    azure_k8s_egress_allowed_destinations                    = []                    ### NOTE: It is possible to use FQDN or ip addresses as destinations. Destination ports can provided as range or single port.
                                                                                      ### Example: [ "google.com:443-445", "100.101.102.103:443" ]
    azurerm_front_door_configuration = {
      subscription_id             = "<placeholder>"
      profile_name                = "buddywise-afd-prod-1"
      profile_resource_group_name = "buddywise-afd"
      endpoint_name               = "buddywise-afd-prod-1"
      certificate_secret_name     = "buddywise-afd-prod-wildcard-buddywise-cloud-com-latest"
      private_link_service_name   = "innovator-instance-pls"
      health_probe_enabled        = false
      waf_policy_custom_rules     = [
        {
          name                           = "grafanawhitelist"
          enabled                        = true
          priority                       = 10
          rate_limit_duration_in_minutes = 1
          rate_limit_threshold           = 10
          type                           = "MatchRule"
          action                         = "Block"
          match_conditions               = [
            {
              match_variable     = "RequestUri"
              operator           = "Contains"
              negation_condition = false
              transforms         = ["Lowercase"]
              match_values       = ["/api/prom", "/loki/api", "/prometheus", "/tempo"]
            },
            {
              match_variable     = "SocketAddr"
              operator           = "IPMatch"
              negation_condition = true
              match_values       = ["20.163.247.19/32", "172.173.202.77/32"]
            }
          ]
        },
        {
          name                           = "whitelist"
          enabled                        = true
          priority                       = 20
          rate_limit_duration_in_minutes = 1
          rate_limit_threshold           = 10
          type                           = "MatchRule"
          action                         = "Block"
          match_conditions               = [
            {
              match_variable     = "SocketAddr"
              operator           = "IPMatch"
              negation_condition = true
              match_values       = [
                                    # buddywise IP sources
                                    ["0.0.0.0/0"],
                                    # Customer IP sources
                                    []
                                   ]
            }
          ]
        }
      ]
    }

    azure_k8s_cluster_nginx_ingress_whitelist = [
      {
        "name"                    = "buddywise_whitelist"
        "priority"                = "400"
        "direction"               = "Inbound"
        "access"                  = "Allow"
        "protocol"                = "Tcp"
        "source_port_range"       = "*"
        "destination_port_ranges" = ["443"]
        "source_address_prefix"   = null
        "source_address_prefixes" = ["0.0.0.0/0"]
      }
    ]

    additional_key_vault_secrets = []

    azure_k8s_default_node_pool = {
      name                      = "default"
      enable_auto_scaling       = true
      min_count                 = 3
      max_count                 = 3
      node_count                = 3
      vm_size                   = "Standard_D4as_v5" #Standard_E4ads_v5
      type                      = "VirtualMachineScaleSets"
      os_disk_type              = "Managed"
      os_sku                    = "Ubuntu"
      max_pods                  = 110
    }

    azure_k8s_additional_node_pool = [
      {
        name                = "boost"
        enable_auto_scaling = true
        min_count           = 0
        max_count           = 3
        node_count          = 3
        vm_size             = "Standard_D4as_v5" #Standard_E4ads_v5
        os_disk_type        = "Managed"
        os_type             = "Linux"
        os_sku              = "Ubuntu"
        max_pods            = 110
      }
    ]

    azure_k8s_network_profile = {
      network_plugin          = "azure"
      network_mode            = "transparent"
      network_policy          = "azure"
      dns_service_ip          = "10.0.8.10"
      docker_bridge_cidr      = "172.17.0.1/16"
      service_cidr            = "10.0.8.0/24"
      load_balancer_sku       = "standard"
      outbound_type           = "loadBalancer"
    }

    azure_k8s_auto_scaler_profile = {
      balance_similar_node_groups      = false
      expander                         = "random"
      max_graceful_termination_sec     = 600
      max_node_provisioning_time       = "15m"
      max_unready_nodes                = 3
      max_unready_percentage           = 45
      new_pod_scale_up_delay           = "10s"
      scale_down_delay_after_add       = "10m"
      scale_down_delay_after_delete    = "10s"
      scale_down_delay_after_failure   = "3m"
      scan_interval                    = "10s"
      scale_down_unneeded              = "10m"
      scale_down_unready               = "20m"
      scale_down_utilization_threshold = 0.5
      empty_bulk_delete_max            = 10
      skip_nodes_with_local_storage    = false
      skip_nodes_with_system_pods      = true
    }

    azure_k8s_helm_charts = [
      {
        chart_name                = "egresscontroller"
        release_name              = "egresscontroller"
        version                   = "0.0.1"
        k8s_namespace             = "egresscontroller"
        external_source           = "oci://buddywisegcs.azurecr.io/charts"
        registry_type             = "public"
        namespace_resource_qouta  = {
            requests_cpu          = "190m"
            requests_memory       = "192Mi"
            limits_cpu            = "550m"
            limits_memory         = "640Mi"
        }
        containers          = [
          {
            container_name  = "egresscontrollerservice"
            image_name      = "egresscontroller"
            image_version   = "0.0.4"
            image_source    = "buddywisegcs.azurecr.io/images"
            requests_cpu    = "90m"
            requests_memory = "64Mi"
            limits_cpu      = "250m"
            limits_memory   = "256Mi"
          },
          {
            container_name  = "egresscontrollernamespacewatcher"
            image_name      = "egresscontroller"
            image_version   = "0.0.4"
            image_source    = "buddywisegcs.azurecr.io/images"
            requests_cpu    = "10m"
            requests_memory = "64Mi"
            limits_cpu      = "50m"
            limits_memory   = "128Mi"
          }
        ]
      },
      {
        chart_name                                     = "infrastructure"
        release_name                                   = "infrastructure"
        version                                        = "6.1.2"
        k8s_namespace                                  = "infrastructure"
        nginx_enabled                                  = true
        nginx_resources_requests_cpu                   = "75m"
        nginx_resources_requests_memory                = "150Mi"
        nginx_resources_limits_cpu                     = "150m"
        nginx_resources_limits_memory                  = "300Mi"
        redis_enabled                                  = true
        redis_resources_requests_cpu                   = "50m"
        redis_resources_requests_memory                = "500Mi"
        redis_resources_limits_cpu                     = "100m"
        redis_resources_limits_memory                  = "800Mi"
        rabbitmq_enabled                               = true
        rabbitmq_resources_requests_cpu                = "100m"
        rabbitmq_resources_requests_memory             = "150Mi"
        rabbitmq_resources_limits_cpu                  = "200m"
        rabbitmq_resources_limits_memory               = "300Mi"
        external_source                                = "oci://buddywisepublic.azurecr.io/charts"
        registry_type                                  = "public"
      }
    ]

    k8s_rbac_roles = [
      {
        role_name       = "view",
        role_type       = "static",
        role_kind       = "built-in",
        role_membership = [
          # {
          #   principal_name = "Buddywise Management",
          #   principal_type = "group",
          #   principal_object_id = "<placeholder>"
          # },
          # {
          #   principal_name = "Buddywise Operators",
          #   principal_type = "group",
          #   principal_object_id = "<placeholder>"
          # },
          # {
          #   principal_name = "Buddywise Security Officers",
          #   principal_type = "group",
          #   principal_object_id = "<placeholder>"
          # }
        ]
      },
      {
        role_name              = "contributor-minimal",
        role_type              = "static",
        role_kind              = "custom",
        role_membership        = [],
        role_rules             = [
          {
            api_groups = [""]
            resources  = ["secrets"]
            verbs      = ["list"]
          },
          {
            api_groups = [""]
            resources  = ["namespaces"]
            verbs      = ["get", "list", "create", "watch"]
          }
        ]
      },
      {
        role_name              = "network-policy-contributor",
        role_type              = "static",
        role_kind              = "custom",
        role_membership        = [],
        role_rules             = [
          {
            api_groups = ["networking.k8s.io"]
            resources  = ["networkpolicies"]
            verbs      = ["get", "create", "update", "delete", "patch"]
          }
        ]
      }
    ]

    k8s_network_policies                = [
      {
        k8s_network_policy_name         = "nginx.whitelist"
        k8s_network_policy_pod_selector = [{
          match_expressions = [
            {
              key      = "app.kubernetes.io/name"
              operator = "In"
              values   = ["nginx"]
            },
            {
              key      = "app.kubernetes.io/instance"
              operator = "In"
              values   = ["infrastructure"]
            }
          ]
        }]
        k8s_network_policy_rules        = {
          ingress       = [
            {
              ip_block  = [{
                cidr    = "0.0.0.0/0"
                #except = []
              }]
              protocol           = "TCP"
              port               = "443"
            }
          ]
        }
      },
      {
        k8s_network_policy_name         = "nginx.internal"
        k8s_network_policy_pod_selector = [{
          match_expressions = [
            {
              key      = "app.kubernetes.io/name"
              operator = "In"
              values   = ["nginx"]
            },
            {
              key      = "app.kubernetes.io/instance"
              operator = "In"
              values   = ["infrastructure"]
            }
          ]
        }]
        k8s_network_policy_rules        = {
          ingress       = [
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["nginx"]
                  },
                  {
                    key      = "app.kubernetes.io/instance"
                    operator = "In"
                    values   = ["infrastructure"]
                  }
                ]
              }]
            }
          ],
          egress       = [
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["nginx"]
                  },
                  {
                    key      = "app.kubernetes.io/instance"
                    operator = "In"
                    values   = ["infrastructure"]
                  }
                ]
              }]
            }
          ]
        }
      },
      {
        k8s_network_policy_name         = "redis.internal"
        k8s_network_policy_pod_selector = [{
          match_expressions = [
            {
              key      = "app.kubernetes.io/name"
              operator = "In"
              values   = ["redis"]
            },
            {
              key      = "app.kubernetes.io/instance"
              operator = "In"
              values   = ["infrastructure"]
            }
          ]
        }]
        k8s_network_policy_rules        = {
          ingress       = [
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["redis"]
                  },
                  {
                    key      = "app.kubernetes.io/instance"
                    operator = "In"
                    values   = ["infrastructure"]
                  }
                ]
              }]
            },
            {
              namespace_selector = [{
                match_expressions = [
                  {
                    key      = "kubernetes.io/metadata.name"
                    operator = "In"
                    values   = ["jobs"]
                  }
                ]
              }]
              pod_selector       = [{}]
              protocol           = "TCP"
              port               = "6379"
            }
          ],
          egress       = [
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["redis"]
                  },
                  {
                    key      = "app.kubernetes.io/instance"
                    operator = "In"
                    values   = ["infrastructure"]
                  }
                ]
              }]
            }
          ]
        }
      },
      {
        k8s_network_policy_name         = "rabbitmq.internal"
        k8s_network_policy_pod_selector = [{
          match_expressions = [
            {
              key      = "app.kubernetes.io/name"
              operator = "In"
              values   = ["rabbitmq"]
            },
            {
              key      = "app.kubernetes.io/instance"
              operator = "In"
              values   = ["infrastructure"]
            }
          ]
        }]
        k8s_network_policy_rules        = {
          ingress       = [
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["rabbitmq"]
                  },
                  {
                    key      = "app.kubernetes.io/instance"
                    operator = "In"
                    values   = ["infrastructure"]
                  }
                ]
              }]
            },
            {
              namespace_selector = [{
                match_expressions = [
                  {
                    key      = "kubernetes.io/metadata.name"
                    operator = "In"
                    values   = ["jobs"]
                  }
                ]
              }]
              pod_selector       = [{}]
              protocol           = "TCP"
              port               = "15672"
            }
          ],
          egress       = [
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["rabbitmq"]
                  },
                  {
                    key      = "app.kubernetes.io/instance"
                    operator = "In"
                    values   = ["infrastructure"]
                  }
                ]
              }]
            }
          ]
        }
      }
    ]

    azure_nsg_rules                  = []
  }/*,
  {
    azure_k8s_cluster_index                                  = "02"
    azure_k8s_cluster_location                               = "westus3"
    azure_k8s_vnet_address_space                             = ["10.0.20.0/22"]
    azure_k8s_cluster_availability_zones                     = ["1","2","3"]
    azure_k8s_service_vnet_address_space                     = ["10.0.24.0/24"]
    azure_vault_sa_backup_enabled                            = true
    azure_core_storage_account_type                          = "ZRS"
    azure_core_storage_account_tier                          = "Standard"
    azure_core_storage_account_access_tier                   = "Hot"
    azure_core_storage_account_kind                          = "StorageV2"
    azure_sql_database_maximum_size_bytes                    = "2147483648"
    azure_k8s_cluster_version                                = "1.30.0"
    azure_k8s_cluster_sku_tier                               = "Standard" ### If an SLA is required, use the "Paid" tier sku.
    azure_k8s_cluster_azure_policy_enabled                   = false
    azure_k8s_cluster_local_account_disabled                 = false
    azure_k8s_cluster_role_based_access_control_enabled      = true
    azure_k8s_cluster_oidc_issuer_enabled                    = true
    azure_k8s_cluster_workload_identity_enabled              = true
    azure_k8s_cluster_admin_group_object_ids                 = ["4a9c2c7d-22b5-4ec2-90b5-7468f894dfc0"]
    azure_k8s_cluster_azure_rbac_enabled                     = false
    azure_k8s_cluster_system_storage_type                    = "Premium_ZRS"
    azure_k8s_private_cluster_enabled                        = true
    azure_k8s_cluster_admin_username                         = "buddywise-admin"
    azure_k8s_cluster_nginx_ingress_fqdn  	                 = "*.buddywise-cloud.com"     ### NOTE: each domain label must be at least 3 characters long. For test purposes it is necessary to use fqdn "*.qa.buddywise-cloud.com" with appropriate certificate data.
    azure_k8s_cluster_nginx_ingress_pls_enabled              = true                   ### should be true if azure_k8s_cluster_nginx_ingress_access_mode = "private-s2s" || "private-afd"
    azure_k8s_cluster_nginx_ingress_access_mode              = "private-afd"          ### possible values: "private-afd" (for public environments with AFD (default)), "private-s2s" (for private environments with VPN), "public" (for public environments without AFD)

    ### IMPORTANT: "private-afd" is only supported in the following regions: brazilsouth, canadacentral, centralus, eastus, eastus2, southcentralus, westus3, francecentral, germanywestcentral, northeurope, norwayeast, uksouth, westeurope, swedencentral, southafricanorth, australiaeast, centralindia, japaneast, koreacentral, eastasia.
    ### https://learn.microsoft.com/en-us/azure/frontdoor/private-link#region-availability

    azure_k8s_cluster_nginx_ingress_public_dns_creation_mode = "auto"                 ### Possible values auto, manual. Auto is applicable only for public ingress controller for buddywise-cloud.com and buddywiseqa.com domains. The necessary credentials shoud be provided: using appropriate variable group for buddywiseqa.com DNS records management or using CloudFlare API token for buddywise-cloud.com DNS records management.
    azure_k8s_ingress_public_ip                              = ""                     ### optional parameter if azure_k8s_cluster_nginx_ingress_access_mode == "public"
    azure_k8s_ingress_public_ip_resource_group_id            = ""                     ### optional parameter if azure_k8s_cluster_nginx_ingress_access_mode == "public"
    azure_k8s_egress_allowed_innovator_componets	           = "server"                     ### option to filter innovator components that are allowed outbound access. Applicable only if azure_k8s_egress_allowed_destinations is not empty. Possible values: "server, oauth, agent, client, conversion, vault"
    azure_k8s_egress_allowed_destinations                    = []                    ### NOTE: It is possible to use FQDN or ip addresses as destinations. Destination ports can provided as range or single port.
                                                                                      ### Example: [ "google.com:443-445", "100.101.102.103:443" ]
    azurerm_front_door_configuration = {
      subscription_id             = "<placeholder>"
      profile_name                = "buddywise-afd-prod-1"
      profile_resource_group_name = "buddywise-afd"
      endpoint_name               = "buddywise-afd-prod-1"
      certificate_secret_name     = "buddywise-afd-prod-wildcard-buddywise-cloud-com-latest"
      private_link_service_name   = "pls"
      health_probe_enabled        = false
      waf_policy_custom_rules     = [
        {
          name                           = "whitelist"
          enabled                        = true
          priority                       = 20
          rate_limit_duration_in_minutes = 1
          rate_limit_threshold           = 10
          type                           = "MatchRule"
          action                         = "Block"
          match_conditions               = [
            {
              match_variable     = "SocketAddr"
              operator           = "IPMatch"
              negation_condition = true
              match_values       = [
                                    # buddywise IP sources
                                    ["0.0.0.0/0"],
                                    # Customer IP sources
                                    []
                                   ]
            }
          ]
        }
      ]
    }

    azure_k8s_cluster_nginx_ingress_whitelist = [
      {
        "name"                    = "whitelist"
        "priority"                = "400"
        "direction"               = "Inbound"
        "access"                  = "Allow"
        "protocol"                = "Tcp"
        "source_port_range"       = "*"
        "destination_port_ranges" = ["443"]
        "source_address_prefix"   = null
        "source_address_prefixes" = ["0.0.0.0/0"]
      }
    ]

    additional_key_vault_secrets = []

    azure_k8s_default_node_pool = {
      name                      = "default"
      enable_auto_scaling       = true
      min_count                 = 2
      max_count                 = 3
      node_count                = 3
      vm_size                   = "Standard_D4as_v5" #Standard_E4ads_v5
      type                      = "VirtualMachineScaleSets"
      os_disk_type              = "Managed"
      os_sku                    = "Ubuntu"
      max_pods                  = 110
    }

    azure_k8s_additional_node_pool = [
      {
        name                = "boost"
        enable_auto_scaling = true
        min_count           = 0
        max_count           = 3
        node_count          = 3
        vm_size             = "Standard_D4as_v5" #Standard_E4ads_v5
        os_disk_type        = "Managed"
        os_type             = "Linux"
        os_sku              = "Ubuntu"
        max_pods            = 110
      }
    ]

    azure_k8s_network_profile = {
      network_plugin          = "azure"
      network_mode            = "transparent"
      network_policy          = "azure"
      dns_service_ip          = "10.0.11.10"
      docker_bridge_cidr      = "172.17.0.1/16"
      service_cidr            = "10.0.11.0/24"
      load_balancer_sku       = "standard"
      outbound_type           = "loadBalancer"
    }

    azure_k8s_auto_scaler_profile = {
      balance_similar_node_groups      = false
      expander                         = "random"
      max_graceful_termination_sec     = 600
      max_node_provisioning_time       = "15m"
      max_unready_nodes                = 3
      max_unready_percentage           = 45
      new_pod_scale_up_delay           = "10s"
      scale_down_delay_after_add       = "10m"
      scale_down_delay_after_delete    = "10s"
      scale_down_delay_after_failure   = "3m"
      scan_interval                    = "10s"
      scale_down_unneeded              = "10m"
      scale_down_unready               = "20m"
      scale_down_utilization_threshold = 0.5
      empty_bulk_delete_max            = 10
      skip_nodes_with_local_storage    = false
      skip_nodes_with_system_pods      = true
    }

    azure_k8s_helm_charts             = [
      {
        chart_name                = "egresscontroller"
        release_name              = "egresscontroller"
        version                   = "0.0.1"
        k8s_namespace             = "egresscontroller"
        external_source           = "oci://buddywisegcs.azurecr.io/charts"
        registry_type             = "public"
        namespace_resource_qouta  = {
            requests_cpu          = "190m"
            requests_memory       = "192Mi"
            limits_cpu            = "550m"
            limits_memory         = "640Mi"
        }
        containers          = [
          {
            container_name  = "egresscontrollerservice"
            image_name      = "egresscontroller"
            image_version   = "0.0.4"
            image_source    = "buddywisegcs.azurecr.io/images"
            requests_cpu    = "90m"
            requests_memory = "64Mi"
            limits_cpu      = "250m"
            limits_memory   = "256Mi"
          },
          {
            container_name  = "egresscontrollernamespacewatcher"
            image_name      = "egresscontroller"
            image_version   = "0.0.4"
            image_source    = "buddywisegcs.azurecr.io/images"
            requests_cpu    = "10m"
            requests_memory = "64Mi"
            limits_cpu      = "50m"
            limits_memory   = "128Mi"
          }
        ]
      },
      {
        chart_name                                     = "infrastructure"
        release_name                                   = "infrastructure"
        version                                        = "6.1.2"
        k8s_namespace                                  = "infrastructure"
        nginx_enabled                                  = true
        nginx_resources_requests_cpu                   = "75m"
        nginx_resources_requests_memory                = "150Mi"
        nginx_resources_limits_cpu                     = "150m"
        nginx_resources_limits_memory                  = "300Mi"
        redis_enabled                                  = true
        redis_resources_requests_cpu                   = "50m"
        redis_resources_requests_memory                = "500Mi"
        redis_resources_limits_cpu                     = "100m"
        redis_resources_limits_memory                  = "800Mi"
        rabbitmq_enabled                               = false
        rabbitmq_resources_requests_cpu                = "100m"
        rabbitmq_resources_requests_memory             = "150Mi"
        rabbitmq_resources_limits_cpu                  = "200m"
        rabbitmq_resources_limits_memory               = "300Mi"
        external_source                                = "oci://buddywisepublic.azurecr.io/charts"
        registry_type                                  = "public"
      }
    ]

    k8s_rbac_roles = [
      {
        role_name       = "view",
        role_type       = "static",
        role_kind       = "built-in",
        role_membership = [
          {
            principal_name = "Buddywise Management",
            principal_type = "group",
            principal_object_id = "82b1a78d-4671-4acb-ad56-44b7c6d749c7"
          },
          {
            principal_name = "Buddywise Operators",
            principal_type = "group",
            principal_object_id = "cbe5c23e-9e13-43aa-9de1-6467e9d6d507"
          },
          {
            principal_name = "Buddywise Security Officers",
            principal_type = "group",
            principal_object_id = "7045261f-3ecd-4db5-9449-c10aee312a1d"
          }
        ]
      },
      {
        role_name              = "contributor-minimal",
        role_type              = "static",
        role_kind              = "custom",
        role_membership        = [],
        role_rules             = [
          {
            api_groups = [""]
            resources  = ["secrets"]
            verbs      = ["list"]
          },
          {
            api_groups = [""]
            resources  = ["namespaces"]
            verbs      = ["get", "list", "create", "watch"]
          }
        ]
      },
      {
        role_name              = "network-policy-contributor",
        role_type              = "static",
        role_kind              = "custom",
        role_membership        = [],
        role_rules             = [
          {
            api_groups = ["networking.k8s.io"]
            resources  = ["networkpolicies"]
            verbs      = ["get", "create", "update", "delete", "patch"]
          }
        ]
      },
      {
        role_name              = "stg",
        role_type              = "dynamic",
        role_namespace_pattern = "^g-.*$",
        role_membership        = [
          {
            principal_name = "GCS Operators",
            principal_type = "group",
            principal_object_id = "cbe5c23e-9e13-43aa-9de1-6467e9d6d507"
          },
          {
            principal_name = "GCS Product Support",
            principal_type = "group",
            principal_object_id = "dcafae0b-877e-4e12-a4be-6295f4a8e728"
          },
          {
            principal_name = "stg-deploy-agents", // Pattern for Azure Key Vault secret with msi principal_object_id
            principal_type = "user",
            principal_object_id = "msi"
          }
        ]
      },
      {
        role_name              = "prd",
        role_type              = "dynamic",
        role_namespace_pattern = "^p-.*$",
        role_membership        = [
          {
            principal_name = "GCS Operators",
            principal_type = "group",
            principal_object_id = "cbe5c23e-9e13-43aa-9de1-6467e9d6d507"
          },
          {
            principal_name = "GCS Product Support",
            principal_type = "group",
            principal_object_id = "dcafae0b-877e-4e12-a4be-6295f4a8e728"
          },
          {
            principal_name = "prd-deploy-agents", // Pattern for Azure Key Vault secret with msi principal_object_id
            principal_type = "user",
            principal_object_id = "msi"
          }
        ]
      }
    ]

    k8s_network_policies                = [
      {
        k8s_network_policy_name         = "nginx.whitelist"
        k8s_network_policy_pod_selector = [{
          match_expressions = [
            {
              key      = "app.kubernetes.io/name"
              operator = "In"
              values   = ["nginx"]
            },
            {
              key      = "app.kubernetes.io/instance"
              operator = "In"
              values   = ["infrastructure"]
            }
          ]
        }]
        k8s_network_policy_rules        = {
          ingress       = [
            {
              ip_block  = [{
                cidr    = "0.0.0.0/0"
                #except = []
              }]
              protocol           = "TCP"
              port               = "443"
            }
          ]
        }
      },
      {
        k8s_network_policy_name         = "nginx.internal"
        k8s_network_policy_pod_selector = [{
          match_expressions = [
            {
              key      = "app.kubernetes.io/name"
              operator = "In"
              values   = ["nginx"]
            },
            {
              key      = "app.kubernetes.io/instance"
              operator = "In"
              values   = ["infrastructure"]
            }
          ]
        }]
        k8s_network_policy_rules        = {
          ingress       = [
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["nginx"]
                  },
                  {
                    key      = "app.kubernetes.io/instance"
                    operator = "In"
                    values   = ["infrastructure"]
                  }
                ]
              }]
            }
          ],
          egress       = [
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["nginx"]
                  },
                  {
                    key      = "app.kubernetes.io/instance"
                    operator = "In"
                    values   = ["infrastructure"]
                  }
                ]
              }]
            }
          ]
        }
      },
      {
        k8s_network_policy_name         = "redis.internal"
        k8s_network_policy_pod_selector = [{
          match_expressions = [
            {
              key      = "app.kubernetes.io/name"
              operator = "In"
              values   = ["redis"]
            },
            {
              key      = "app.kubernetes.io/instance"
              operator = "In"
              values   = ["infrastructure"]
            }
          ]
        }]
        k8s_network_policy_rules        = {
          ingress       = [
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["redis"]
                  },
                  {
                    key      = "app.kubernetes.io/instance"
                    operator = "In"
                    values   = ["infrastructure"]
                  }
                ]
              }]
            },
            {
              namespace_selector = [{
                match_expressions = [
                  {
                    key      = "kubernetes.io/metadata.name"
                    operator = "In"
                    values   = ["jobs"]
                  }
                ]
              }]
              pod_selector       = [{}]
              protocol           = "TCP"
              port               = "6379"
            }
          ],
          egress       = [
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["redis"]
                  },
                  {
                    key      = "app.kubernetes.io/instance"
                    operator = "In"
                    values   = ["infrastructure"]
                  }
                ]
              }]
            }
          ]
        }
      },
      {
        k8s_network_policy_name         = "rabbitmq.internal"
        k8s_network_policy_pod_selector = [{
          match_expressions = [
            {
              key      = "app.kubernetes.io/name"
              operator = "In"
              values   = ["rabbitmq"]
            },
            {
              key      = "app.kubernetes.io/instance"
              operator = "In"
              values   = ["infrastructure"]
            }
          ]
        }]
        k8s_network_policy_rules        = {
          ingress       = [
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["rabbitmq"]
                  },
                  {
                    key      = "app.kubernetes.io/instance"
                    operator = "In"
                    values   = ["infrastructure"]
                  }
                ]
              }]
            },
            {
              namespace_selector = [{
                match_expressions = [
                  {
                    key      = "kubernetes.io/metadata.name"
                    operator = "In"
                    values   = ["jobs"]
                  }
                ]
              }]
              pod_selector       = [{}]
              protocol           = "TCP"
              port               = "15672"
            }
          ],
          egress       = [
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["rabbitmq"]
                  },
                  {
                    key      = "app.kubernetes.io/instance"
                    operator = "In"
                    values   = ["infrastructure"]
                  }
                ]
              }]
            }
          ]
        }
      },
      {
        k8s_network_policy_name         = "default.dns.infrastructure"
        k8s_network_policy_pod_selector = [{
          match_expressions = [
            {
              key      = "app.kubernetes.io/name"
              operator = "In"
              values   = ["redis", "rabbitmq", "nginx", "nsauthorizer", "reflector", "aicdresourceoperator"]
            },
            {
              key      = "app.kubernetes.io/instance"
              operator = "In"
              values   = ["infrastructure"]
            }
          ]
        }]
        k8s_network_policy_rules        = {
          egress       = [
            {
              namespace_selector = [{
                match_expressions = [
                  {
                    key      = "kubernetes.io/metadata.name"
                    operator = "In"
                    values   = ["kube-system"]
                  }
                ]
              }]
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "k8s-app"
                    operator = "In"
                    values   = ["kube-dns"]
                  }
                ]
              }]
              protocol           = "UDP"
              port               = "53"
            },
            {
              namespace_selector = [{
                match_expressions = [
                  {
                    key      = "kubernetes.io/metadata.name"
                    operator = "In"
                    values   = ["kube-system"]
                  }
                ]
              }]
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "k8s-app"
                    operator = "In"
                    values   = ["kube-dns"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "53"
            }
          ]
        }
      },
      {
        k8s_network_policy_name         = "allow.kube.api"
        k8s_network_policy_pod_selector = [{
          match_expressions = [
            {
              key      = "app.kubernetes.io/name"
              operator = "In"
              values   = ["redis", "rabbitmq", "nginx", "nsauthorizer", "reflector", "aicdresourceoperator"]
            },
            {
              key      = "app.kubernetes.io/instance"
              operator = "In"
              values   = ["infrastructure"]
            }
          ]
        }]
        k8s_network_policy_rules        = {
          egress        = [
            {
              ip_block  = [{
                cidr    = "{kube_api_endpoints}"
                #except = []
              }]
              protocol           = "TCP"
              port               = "443"
            }
          ]
        }
      },
      {
        k8s_network_policy_name         = "default.deny.infrastructure"
        k8s_network_policy_pod_selector = [{}]
        k8s_network_policy_rules        = {}
        k8s_network_policy_types        = ["Ingress", "Egress"]
      },
      {
        k8s_network_policy_name         = "default.deny.monitoring"
        k8s_network_policy_namespace    = "monitoring"
        k8s_network_policy_pod_selector = [{}]
        k8s_network_policy_rules        = {}
        k8s_network_policy_types        = ["Ingress", "Egress"]
      },
      {
        k8s_network_policy_name         = "default.dns.monitoring"
        k8s_network_policy_namespace    = "monitoring"
        k8s_network_policy_pod_selector = [{}]
        k8s_network_policy_rules        = {
          egress       = [
            {
              namespace_selector = [{
                match_expressions = [
                  {
                    key      = "kubernetes.io/metadata.name"
                    operator = "In"
                    values   = ["kube-system"]
                  }
                ]
              }]
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "k8s-app"
                    operator = "In"
                    values   = ["kube-dns"]
                  }
                ]
              }]
              protocol           = "UDP"
              port               = "53"
            },
            {
              namespace_selector = [{
                match_expressions = [
                  {
                    key      = "kubernetes.io/metadata.name"
                    operator = "In"
                    values   = ["kube-system"]
                  }
                ]
              }]
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "k8s-app"
                    operator = "In"
                    values   = ["kube-dns"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "53"
            }
          ]
        }
      },
      {
        k8s_network_policy_name         = "nginx.monitoring"
        k8s_network_policy_namespace    = "infrastructure"
        k8s_network_policy_pod_selector = [{
          match_expressions = [
            {
              key      = "app.kubernetes.io/name"
              operator = "In"
              values   = ["nginx"]
            },
            {
              key      = "app.kubernetes.io/instance"
              operator = "In"
              values   = ["infrastructure"]
            }
          ]
        }]
        k8s_network_policy_rules        = {
          ingress      = [
            {
              namespace_selector = [{
                match_expressions = [
                  {
                    key      = "kubernetes.io/metadata.name"
                    operator = "In"
                    values   = ["monitoring"]
                  }
                ]
              }]
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/component"
                    operator = "In"
                    values   = ["server"]
                  },
                  {
                    key      = "app.kubernetes.io/part-of"
                    operator = "In"
                    values   = ["prometheus"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "10254"
            }
          ],
          egress      = [
            {
              namespace_selector = [{
                match_expressions = [
                  {
                    key      = "kubernetes.io/metadata.name"
                    operator = "In"
                    values   = ["monitoring"]
                  }
                ]
              }]
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/component"
                    operator = "In"
                    values   = ["server"]
                  },
                  {
                    key      = "app.kubernetes.io/part-of"
                    operator = "In"
                    values   = ["prometheus"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "9090"
            },
            {
              namespace_selector = [{
                match_expressions = [
                  {
                    key      = "kubernetes.io/metadata.name"
                    operator = "In"
                    values   = ["monitoring"]
                  }
                ]
              }]
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["loki"]
                  },
                  {
                    key      = "app.kubernetes.io/part-of"
                    operator = "In"
                    values   = ["memberlist"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "3100"
            },
            {
              namespace_selector = [{
                match_expressions = [
                  {
                    key      = "kubernetes.io/metadata.name"
                    operator = "In"
                    values   = ["monitoring"]
                  }
                ]
              }]
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["tempo"]
                  },
                  {
                    key      = "app.kubernetes.io/instance"
                    operator = "In"
                    values   = ["tempo"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "3100"
            }
          ]
        }
      },
            {
        k8s_network_policy_name         = "loki.monitoring"
        k8s_network_policy_namespace    = "monitoring"
        k8s_network_policy_pod_selector = [{
          match_expressions = [
            {
              key      = "app.kubernetes.io/name"
              operator = "In"
              values   = ["loki"]
            },
            {
              key      = "app.kubernetes.io/part-of"
              operator = "In"
              values   = ["memberlist"]
            }
          ]
        }]
        k8s_network_policy_rules        = {
          ingress      = [
            {
              namespace_selector = [{
                match_expressions = [
                  {
                    key      = "kubernetes.io/metadata.name"
                    operator = "In"
                    values   = ["infrastructure"]
                  }
                ]
              }]
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["nginx"]
                  },
                  {
                    key      = "app.kubernetes.io/instance"
                    operator = "In"
                    values   = ["infrastructure"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "3100"
            },
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/component"
                    operator = "In"
                    values   = ["server"]
                  },
                  {
                    key      = "app.kubernetes.io/part-of"
                    operator = "In"
                    values   = ["prometheus"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "3100"
            },
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["promtail"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "3100"
            },
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["opentelemetry-collector"]
                  },
                  {
                    key      = "app.kubernetes.io/instance"
                    operator = "In"
                    values   = ["opentelemetry-collector"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "3100"
            },
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["loki"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "3100"
            },
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["loki"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "9095"
            },
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["loki"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "7946"
            }
          ],
          egress        = [
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["loki"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "3100"
            },
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["loki"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "9095"
            },
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["loki"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "7946"
            },
            {
              ip_block  = [{
                cidr    = "{azure_loki_blob_endpoint}"
                #except = []
              }]
              protocol           = "TCP"
              port               = "443"
            }
          ]
        }
      },
      {
        k8s_network_policy_name         = "tempo.monitoring"
        k8s_network_policy_namespace    = "monitoring"
        k8s_network_policy_pod_selector = [{
          match_expressions = [
            {
              key      = "app.kubernetes.io/name"
              operator = "In"
              values   = ["tempo"]
            },
            {
              key      = "app.kubernetes.io/instance"
              operator = "In"
              values   = ["tempo"]
            }
          ]
        }]
        k8s_network_policy_rules        = {
          ingress      = [
            {
              namespace_selector = [{
                match_expressions = [
                  {
                    key      = "kubernetes.io/metadata.name"
                    operator = "In"
                    values   = ["infrastructure"]
                  }
                ]
              }]
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["nginx"]
                  },
                  {
                    key      = "app.kubernetes.io/instance"
                    operator = "In"
                    values   = ["infrastructure"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "3100"
            },
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/component"
                    operator = "In"
                    values   = ["server"]
                  },
                  {
                    key      = "app.kubernetes.io/part-of"
                    operator = "In"
                    values   = ["prometheus"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "3100"
            },
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["opentelemetry-collector"]
                  },
                  {
                    key      = "app.kubernetes.io/instance"
                    operator = "In"
                    values   = ["opentelemetry-collector"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "4317"
            },
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["tempo"]
                  },
                  {
                    key      = "app.kubernetes.io/instance"
                    operator = "In"
                    values   = ["tempo"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "3100"
            }
          ],
          egress        = [
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["tempo"]
                  },
                  {
                    key      = "app.kubernetes.io/instance"
                    operator = "In"
                    values   = ["tempo"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "3100"
            },
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["prometheus"]
                  },
                  {
                    key      = "app.kubernetes.io/component"
                    operator = "In"
                    values   = ["server"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "9090"
            },
            {
              ip_block  = [{
                cidr    = "{azure_tempo_blob_endpoint}"
                #except = []
              }]
              protocol           = "TCP"
              port               = "443"
            }
          ]
        }
      },
      {
        k8s_network_policy_name         = "otel.monitoring"
        k8s_network_policy_namespace    = "monitoring"
        k8s_network_policy_pod_selector = [{
          match_expressions = [
            {
              key      = "app.kubernetes.io/name"
              operator = "In"
              values   = ["opentelemetry-collector"]
            },
            {
              key      = "app.kubernetes.io/instance"
              operator = "In"
              values   = ["opentelemetry-collector"]
            }
          ]
        }]
        k8s_network_policy_rules        = {
          ingress      = [
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/component"
                    operator = "In"
                    values   = ["server"]
                  },
                  {
                    key      = "app.kubernetes.io/part-of"
                    operator = "In"
                    values   = ["prometheus"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "8888"
            },
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/component"
                    operator = "In"
                    values   = ["server"]
                  },
                  {
                    key      = "app.kubernetes.io/part-of"
                    operator = "In"
                    values   = ["prometheus"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "8889"
            },
            {
              ip_block  = [{
                cidr    = "{azure_virtual_network_node_address_space}"
                #except = []
              }]
              protocol           = "TCP"
              port               = "4317"
            },
            {
              ip_block  = [{
                cidr    = "{azure_virtual_network_pod_address_space}"
                #except = []
              }]
              protocol           = "TCP"
              port               = "4317"
            },
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["innovator-health", "innovator-login"]
                  },
                  {
                    key      = "app.kubernetes.io/part-of"
                    operator = "In"
                    values   = ["monitoring"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "4318"
            }
          ],
          egress        = [
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["tempo"]
                  },
                  {
                    key      = "app.kubernetes.io/instance"
                    operator = "In"
                    values   = ["tempo"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "4317"
            },
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["loki"]
                  },
                  {
                    key      = "app.kubernetes.io/instance"
                    operator = "In"
                    values   = ["loki"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "3100"
            }
          ]
        }
      },
      {
        k8s_network_policy_name         = "innovator-health.monitoring"
        k8s_network_policy_namespace    = "monitoring"
        k8s_network_policy_pod_selector = [{
          match_expressions = [
            {
              key      = "app.kubernetes.io/name"
              operator = "In"
              values   = ["innovator-health"]
            },
            {
              key      = "app.kubernetes.io/part-of"
              operator = "In"
              values   = ["monitoring"]
            }
          ]
        }]
        k8s_network_policy_rules        = {
          egress        = [
            {
              ip_block  = [{
                cidr    = "{azure_virtual_network_node_address_space}"
                #except = []
              }]
              protocol           = "TCP"
              port               = "8080"
            },
            {
              ip_block  = [{
                cidr    = "{azure_virtual_network_pod_address_space}"
                #except = []
              }]
              protocol           = "TCP"
              port               = "8080"
            },
            {
              ip_block  = [{
                cidr    = "{kube_api_endpoints}"
                #except = []
              }]
              protocol           = "TCP"
              port               = "443"
            },
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["opentelemetry-collector"]
                  },
                  {
                    key      = "app.kubernetes.io/instance"
                    operator = "In"
                    values   = ["opentelemetry-collector"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "4318"
            }
          ]
        }
      },
      {
        k8s_network_policy_name         = "innovator-login.monitoring"
        k8s_network_policy_namespace    = "monitoring"
        k8s_network_policy_pod_selector = [{
          match_expressions = [
            {
              key      = "app.kubernetes.io/name"
              operator = "In"
              values   = ["innovator-login"]
            },
            {
              key      = "app.kubernetes.io/part-of"
              operator = "In"
              values   = ["monitoring"]
            }
          ]
        }]
        k8s_network_policy_rules        = {
          egress        = [
            {
              ip_block  = [{
                cidr    = "{allow_all}"
                #except = []
              }]
              protocol           = "TCP"
              port               = "443"
            },
            {
              ip_block  = [{
                cidr    = "{allow_all}"
                #except = []
              }]
              protocol           = "TCP"
              port               = "53"
            },
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["opentelemetry-collector"]
                  },
                  {
                    key      = "app.kubernetes.io/instance"
                    operator = "In"
                    values   = ["opentelemetry-collector"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "4318"
            },
            {
              namespace_selector = [{
                match_expressions = [
                  {
                    key      = "kubernetes.io/metadata.name"
                    operator = "In"
                    values   = ["infrastructure"]
                  }
                ]
              }]
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["nginx"]
                  },
                  {
                    key      = "app.kubernetes.io/instance"
                    operator = "In"
                    values   = ["infrastructure"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "443"
            }
          ]
        }
      },
      {
        k8s_network_policy_name         = "promtail.monitoring"
        k8s_network_policy_namespace    = "monitoring"
        k8s_network_policy_pod_selector = [{
          match_expressions = [
            {
              key      = "app.kubernetes.io/name"
              operator = "In"
              values   = ["promtail"]
            }
          ]
        }]
        k8s_network_policy_rules        = {
          ingress = [
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/component"
                    operator = "In"
                    values   = ["server"]
                  },
                  {
                    key      = "app.kubernetes.io/part-of"
                    operator = "In"
                    values   = ["prometheus"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "3101"
            }
          ],
          egress      = [
            {
              pod_selector       = [{
                match_expressions = [
                  {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["loki"]
                  }
                ]
              }]
              protocol           = "TCP"
              port               = "3100"
            },
            {
              ip_block  = [{
                cidr    = "{kube_api_endpoints}"
                #except = []
              }]
              protocol           = "TCP"
              port               = "443"
            }
          ]
        }
      }
    ]

    azure_nsg_rules                  = []
  }*/
]