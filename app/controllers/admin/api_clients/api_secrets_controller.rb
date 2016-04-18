class Admin::APIClients::APISecretsController < ApplicationController
  before_action :authenticate_user!

  def update
    @api_client = APIClient.find(params[:api_client_id])
    @api_client.regenerate_api_secret
    flash[:notice] = "L'accès client API a bien été révoqué par regénération de la clef."
  end
end
