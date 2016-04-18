<% if @api_client.persisted? %>
  $('#api_clients').append("<%= j render 'admin/api_clients/api_client', api_client: @api_client %>")
  $('#api_client_container').empty()
  $('#new_api_client_triggered').show()
<% else %>
  $('#api_client_container').html("<%= j render 'admin/api_clients/new', api_client: @api_client %>")
<% end %>

  $('#flash_messages').append("<%= j render 'shared/flash_messages' %>")
