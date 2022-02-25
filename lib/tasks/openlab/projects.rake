namespace :openlab do
  namespace :projects do
    task import_from_yml_dump: :environment do
      projects_raw_data = YAML.load(File.read("./data/projects.yml"))
      projects_data = projects_raw_data.map do |project_raw_data|
        app_id = project_raw_data[:app_id]
        api_client_id = ApiClient.where(app_id: app_id).first.id
        project_raw_data.delete(:app_id)
        project_raw_data[:api_client_id] = api_client_id
        project_raw_data[:created_at] = project_raw_data[:meta][:created_at]
        project_raw_data[:updated_at] = project_raw_data[:meta][:updated_at]
        project_raw_data[:published_at] = project_raw_data[:meta][:published_at]
        project_raw_data.delete(:meta)
        project_raw_data.delete(:id)
        project_raw_data
      end
      projects_data.each do |project_data|
        Project.create!(project_data)
      end      
    end
  end
end