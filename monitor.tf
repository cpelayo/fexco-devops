resource "azurerm_log_analytics_workspace" "aks_logs" {
  name                = "aks-observability"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

#Defines what happens when the alert triggers
resource "azurerm_monitor_action_group" "aks_alerts" {
  name                = "aks-alerts"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "aksalrt"

  email_receiver {
    name          = "email-admin"
    email_address = "cpr_cesar@hotmail.com"
  }
}

resource "azurerm_monitor_metric_alert" "cpu_high" {
  name                = "aks-node-high-cpu"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_kubernetes_cluster.aks.id]
  description         = "Alert when AKS node CPU exceeds 70% for 3 minutes"
  severity            = 2
  frequency           = "PT1M" # evaluate every 1 minute
  window_size         = "PT5M" # look at a 5-minute window
  auto_mitigate       = true

  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "node_cpu_usage_percentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 70
  }

  action {
    action_group_id = azurerm_monitor_action_group.aks_alerts.id
  }
}