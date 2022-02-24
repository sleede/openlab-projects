json.projects @projects do |project|
  json.app_id project.api_client.app_id
  json.app_name project.api_client.name
  json.slug project.slug
  json.name project.name
  #json.description project.description
  json.image_url "#{project.api_client.origin}#{project.image_path}" unless project.image_path.blank?
  #json.project_path project.project_path
  json.project_url "#{project.api_client.origin}#{project.project_path}"
end

json.merge!(@pagination_meta.to_hash)
