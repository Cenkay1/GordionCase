# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "gordion-beap"
  frontend_port_name             = "gordion-feport"
  frontend_ip_configuration_name = "gordion-feip"
  http_setting_name              = "gordion-be-htst"
  listener_name                  = "gordion-httplstn"
  request_routing_rule_name      = "gordion-rqrt"
  redirect_configuration_name    = "gordion-rdrcfg"
}