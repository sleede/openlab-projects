$('#api_client_container').html("<%= j render 'admin/api_clients/edit', api_client: @api_client %>")
$('#new_api_client_triggered').hide()
$('#flash_messages').append("<%= j render 'shared/flash_messages' %>")
