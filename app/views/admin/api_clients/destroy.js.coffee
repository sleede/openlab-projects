if <%= @api_client.destroyed? %>
  $('#api_client-<%= params[:id] %>').remove()

$('#flash_messages').append("<%= j render 'shared/flash_messages' %>")
