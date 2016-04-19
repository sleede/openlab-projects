Elasticsearch::Persistence.client = Elasticsearch::Client.new host: "http://#{Rails.application.secrets.elasticsearch_host}:9200", log: true

Kaminari::Hooks.init
Elasticsearch::Model::Response::Response.__send__ :include, Elasticsearch::Model::Response::Pagination::Kaminari
