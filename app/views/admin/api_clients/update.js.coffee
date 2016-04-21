$('#api_client-<%= @api_client.id %>').replaceWith("<%= j render 'admin/api_clients/api_client', api_client: @api_client %>")
$('#api_client_container').empty()
$('#new_api_client_triggered').show()
$('#flash_messages').append("<%= j render 'shared/flash_messages' %>")
