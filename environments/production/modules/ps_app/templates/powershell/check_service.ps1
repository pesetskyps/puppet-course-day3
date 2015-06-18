$service = get-service  *<%= @servicename %>*
if(-Not $service) {throw "no service <%= @servicename %> installed"}
