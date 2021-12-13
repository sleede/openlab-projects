# frozen_string_literal: true

class Project < ActiveRecord::Base
  include Elasticsearch::Persistence::Repository
  include Elasticsearch::Persistence::Repository::DSL
  include Elasticsearch::Model
  include Concerns::Elasticable

  multi_analyzers = {
    type: 'multi_field',
    fields: {
      std: { type: 'string', analyzer: 'standard' },
      fr: { type: 'string', analyzer: 'french' },
      fr_no_accent: { type: 'string', analyzer: 'french_without_accent' }
    }
  }

  std_and_std_without_accent = {
    type: 'multi_field',
    fields: {
      std: { type: 'string', analyzer: 'standard' },
      std_no_accent: { type: 'string', analyzer: 'standard_without_accent' }
    }
  }

  # attributes
  attribute :slug,          String, mapping: { index: 'not_analyzed', type: 'string' }
  attribute :app_id,        String
  attribute :project_id,    String
  attribute :name,          String,        mapping: multi_analyzers,                          default: ''
  attribute :description,   String,        mapping: multi_analyzers,                          default: ''
  attribute :tags,          String,        mapping: multi_analyzers,                          default: ''
  attribute :machines,      Array[String], mapping: { analyzer: 'standard' }
  attribute :components,    Array[String], mapping: multi_analyzers
  attribute :themes,        Array[String], mapping: multi_analyzers
  attribute :author,        String,        mapping: std_and_std_without_accent, default: ''
  attribute :collaborators, Array[String], mapping: std_and_std_without_accent
  attribute :steps_body,    String,        mapping: multi_analyzers, default: ''
  attribute :image_path,    String,        mapping: { index: 'not_analyzed', type: 'string' }
  attribute :project_path,  String,        mapping: { index: 'not_analyzed', type: 'string' }
  attribute :meta,          Hash[Symbol => Time], mapping: { type: 'object',
                                                             properties: {
                                                               created_at: { type: 'date' },
                                                               updated_at: { type: 'date' },
                                                               published_at: { type: 'date' }
                                                             } }

  # validations
  validates :app_id, :project_id, :project_path, presence: true

  # coerce attributes defining setters
  %i[name description author].each do |attribute|
    define_method "#{attribute}=" do |val|
      super(val.is_a?(Array) ? val[0] : val)
    end
  end

  %i[tags steps_body].each do |attribute|
    define_method "#{attribute}=" do |val|
      super(val.is_a?(Array) ? val.join(' ') : val)
    end
  end

  def self.elastic_id(api_client: nil, app_id: nil, project_id:)
    raise ArgumentError, 'api_client or app_id have to be given' if api_client.nil? && app_id.nil?

    preffix = api_client&.app_id || app_id
    "#{preffix}-#{project_id}"
  end

  def id
    self.class.elastic_id(app_id: app_id, project_id: project_id)
  end
end
