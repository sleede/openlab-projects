json.projects @results do |project|
  json.name project.name
  json.description project.description
  #json.image_path project.image_path
  json.image_url "#{current_api_client.origin}#{project.image_path}"
  #json.project_path project.project_path
  json.project_url "#{current_api_client.origin}#{project.project_path}"
end
