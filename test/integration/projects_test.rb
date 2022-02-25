require 'test_helper'

class ProjectsTest < ActionDispatch::IntegrationTest
  def setup
    super
    @api_client = ApiClient.first
  end

  test "every action needs authentication" do
    get api_v1_projects_path, headers: default_headers
    assert_equal 401, response.status
    
    delete "#{api_v1_projects_path}/123", headers: default_headers
    assert_equal 401, response.status
    patch "#{api_v1_projects_path}/123", headers: default_headers
    assert_equal 401, response.status
    
    post api_v1_projects_path, headers: default_headers
    assert_equal 401, response.status
  end

  # projects#index
  test "projects#index" do
    Project.find_each(&:touch)
    get api_v1_projects_path, params: { q: 't-shirt' }, headers: default_headers(api_client: @api_client)
    json_resp = json_response(response.body)

    assert_equal 200, response.status
    assert json_resp[:projects][0].key?(:name)
    assert json_resp[:projects][0].key?(:image_url)
    assert json_resp[:projects][0].key?(:project_url)

    get api_v1_projects_path, params: { }, headers: default_headers(api_client: @api_client)
    assert_equal 200, response.status
  end

  # projects#create
  test "projects#create success" do
    post api_v1_projects_path, params: {
        project: {
          id: 145,
          name: "Awesome project",
          project_path: "/projects/awesome-project"
        }
      }.to_json,
      headers: default_headers(api_client: @api_client)

    assert_equal 201, response.status
  end

  test "projects#create error because of missing id" do
    post api_v1_projects_path, params: {
        project: {
          name: "Awesome project",
          project_path: "/projects/awesome-project"
        }
      }.to_json,
      headers: default_headers(api_client: @api_client)

    assert_equal 422, response.status
    assert json_response(response.body).key?(:errors)
  end

  # projects#update
  test "projects#update success" do
    project = Project.all.first
    patch "#{api_v1_projects_path}/#{project.id}", params: {
        project: {
          name: "Awesome project",
        }
      }.to_json,
      headers: default_headers(api_client: @api_client)

    assert_equal 200, response.status

    assert_equal "Awesome project", Project.all.first.name
  end

  test "projects#update return http status code 404 if project not found" do
    patch "#{api_v1_projects_path}/987651", params: { }, headers: default_headers(api_client: @api_client)
    assert_equal 404, response.status
  end

  # projects#destroy
  test "projects#destroy" do
    project = Project.all.first
    delete "#{api_v1_projects_path}/#{project.id}", headers: default_headers(api_client: @api_client)

    assert_equal 204, response.status

    delete "#{api_v1_projects_path}/#{project.id}", headers: default_headers(api_client: @api_client)
    assert_equal 404, response.status
  end
end
