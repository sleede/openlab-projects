Elasticsearch::Persistence.client = Elasticsearch::Client.new host: "http://#{Rails.application.secrets.elasticsearch_host}:#{Rails.application.secrets.elasticsearch_port}", log: true

require 'kaminari/models/array_extension'
Elasticsearch::Model::Response::Response.__send__ :include, Elasticsearch::Model::Response::Pagination::Kaminari
