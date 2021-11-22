$("#api_client-<%= @api_client.id %>").replaceWith("<%= j render 'admin/api_clients/api_client', api_client: @api_client %>")
$('#flash_messages').append("<%= j render 'shared/flash_messages' %>")
