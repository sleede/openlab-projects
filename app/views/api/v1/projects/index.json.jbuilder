json.projects @projects do |project|
  json.app_id project.app_id
  json.app_name @api_client_names[project.app_id]
  json.slug project.slug
  json.name project.name
  #json.description project.description
  json.image_url "#{current_api_client.origin}#{project.image_path}" unless project.image_path.blank?
  #json.project_path project.project_path
  json.project_url "#{current_api_client.origin}#{project.project_path}"
end

json.merge!(@pagination_meta)
