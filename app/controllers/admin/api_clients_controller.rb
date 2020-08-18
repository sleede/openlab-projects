class Admin::APIClientsController < ApplicationController
  before_action :authenticate_user!

  def index
    @api_clients = APIClient.order(:created_at)
  end

  def new
    @api_client = APIClient.new
  end

  def edit
    @api_client = APIClient.find(params[:id])
  end

  def update
    @api_client = APIClient.find(params[:id])
    if @api_client.update(api_client_params)
      flash.now[:success] = "Le compte client API a bien été modifié."
    else
      flash.now[:error] = "Le formulaire possède des erreurs."
      render :edit
    end
  end

  def create
    @api_client = APIClient.new(api_client_params)
    if @api_client.save
      flash.now[:success] = "Le compte client API a bien été créé."
    else
      flash.now[:error] = "La création du compte client API a échouée."
    end
  end

  def destroy
    @api_client = APIClient.find(params[:id])
    Project.find_in_batches(query: { bool: { must: [{ match: { app_id: @api_client.app_id }}]}}) do |projects| 
      projects.each do |project| 
        project.destroy 
      end 
    end
    @api_client.destroy!
    flash.now[:notice] = "Le compte client API a bien été supprimé."
  end

  private
    def api_client_params
      params.require(:api_client).permit(:name, :origin)
    end
end
