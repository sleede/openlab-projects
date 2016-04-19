class API::V1::ProjectsController < API::V1::BaseController
  def index
    raise ActionController::ParameterMissing, "params q is needed" if params[:q].blank?

    @results = Search::Project.full_text(params[:q]).results
  end

  def create
    project = Project.new project_params
    project.project_id = params[:project][:id] || params[:project][:project_id]
    project.app_id = current_api_client.app_id

    if project.save
      head :created
    else
      render json: { errors: project.errors }, status: :unprocessable_entity
    end
  end

  def update
    project = find_project

    if project.update project_params
      head :ok
    else
      render json: { errors: project.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    project = find_project
    project.destroy
    head :no_content
  end

  private
    def find_project
      Project.find(project_id)
    end

    def project_id
      Project.elastic_id(api_client: current_api_client, project_id: params[:id])
    end

    def project_params
      params.require(:project).permit(:name, :description, :tags, :machines, :components, :themes,
        :author, :collaborators, :steps_body, :project_path, :image_path
      )
    end
end
