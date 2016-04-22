class API::V1::ProjectsController < API::V1::BaseController
  include Concerns::PaginationHeaders

  def index
    #raise ActionController::ParameterMissing, "params q is needed" if params[:q].blank?

    api_clients = APIClient.pluck(:app_id, :name)
    @api_client_names = Hash[api_clients.map{ |api_client| [api_client[0], api_client[1]] }]


    page, per_page, from = PaginationParams.clean(params[:page], params[:per_page])

    result = if params[:q].present?
      Search::Project.full_text(params[:q], from: from, size: per_page)
    else
      Project.search(sort: { 'meta.published_at': { order: :desc } }, from: from, size: per_page)
    end

    set_pagination_headers(total: result.total, page: page, per_page: per_page)

    @pagination_meta = PaginationMeta.new(total: result.total, page: page, per_page: per_page)

    @projects = result.results
  end

  def create
    project = Project.new project_params
    project.project_id = params[:project][:id] || params[:project][:project_id]
    project.meta = project_meta_params
    project.app_id = current_api_client.app_id

    if project.save
      head :created
    else
      render json: { errors: project.errors }, status: :unprocessable_entity
    end
  end

  def update
    project = find_project

    if project.update project_params.merge(meta: project_meta_params)
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

    def project_meta_params
      params.require(:project).permit(:updated_at, :created_at, :published_at)
    end

    def project_params
      params.require(:project).permit(:slug, :name, :description, :tags, :machines, :components, :themes,
        :author, :collaborators, :steps_body, :project_path, :image_path
      )
    end
end
