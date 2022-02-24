class API::V1::ProjectsController < API::V1::BaseController
  include Concerns::PaginationHeaders

  def index
    page, per_page = PaginationParams.clean(params[:page], params[:per_page])

    @projects = if params[:q].present?
      Project.search(params[:q])
    else
      Project.order(published_at: :desc)
    end

    @projects = @projects.includes(:api_client).page(page).per(per_page)

    set_pagination_headers(total: @projects.total_count, page: page, per_page: per_page)

    @pagination_meta = PaginationMeta.new(total: @projects.total_count, page: page, per_page: per_page)
  end

  def create
    project = Project.new project_params
    project.project_id = params[:project][:id]
    project.api_client = current_api_client

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
      Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:slug, :name, :description, :tags, :machines, :components, :themes,
        :author, :collaborators, :steps_body, :project_path, :image_path, :updated_at, :created_at, :published_at
      )
    end
end
