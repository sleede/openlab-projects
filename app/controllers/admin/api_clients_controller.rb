class Admin::APIClientsController < ApplicationController
  before_action :authenticate_user!

  def index
    @api_clients = ApiClient.order(:created_at)
  end

  def new
    @api_client = ApiClient.new
  end

  def create
    @api_client = ApiClient.new(api_client_params)
    if @api_client.save
      flash[:notice] = "Le compte client API a bien été créé."
    else
      flash[:error] = "La création du compte client API a échouée."
    end
  end

  def destroy
    @api_client = ApiClient.find(params[:id])
    @api_client.destroy!
    flash[:notice] = "Le compte client API a bien été supprimé."
  end

  private
    def api_client_params
      params.require(:api_client).permit(:name, :origin)
    end
end
