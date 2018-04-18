namespace :openlab do
  namespace :elastic do

    task init_index: :environment do
      if elastic_client.indices.exists? index: index_name
        puts "index '#{index_name}' already exists"
      else
        elastic_client.indices.create index: index_name, body: { settings: ElasticConfig.settings, mappings: ElasticConfig.mappings }
      end
    end

    task delete_index: :environment do
      if elastic_client.indices.exists? index: index_name
        elastic_client.indices.delete index: index_name
      else
        puts "index #{index_name} doesn't exist, can't delete it"
      end
    end

    task put_mappings: :environment do
      elastic_client.indices.put_mapping index: index_name, type: Project.document_type, body: Project.mappings
    end

    task setup: :environment do
      Rake::Task["openlab:elastic:delete_index"].invoke
      Rake::Task["openlab:elastic:init_index"].invoke
      Rake::Task["openlab:elastic:put_mappings"].invoke
    end

    task seed: :environment do
      projects_attributes = YAML.load(File.open('test/elastic_fixtures/projects.yml').read)
      projects_attributes.each do |project_attributes|
        Project.create project_attributes
      end
    end

    private
      def elastic_client
        @elastic_client ||= Elasticsearch::Client.new host: "http://#{Rails.application.secrets.elasticsearch_host}:#{Rails.application.secrets.elasticsearch_port}", log: (Rails.env.test? ? false : true)
      end

      def index_name
        [Rails.application.secrets.elasticsearch_index_name, Rails.env].join('_')
      end
  end
end
