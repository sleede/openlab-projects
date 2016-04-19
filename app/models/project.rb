class Project
  include Elasticsearch::Persistence::Model
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

  attribute :app_id, String
  attribute :project_id, String

  attribute :name, String, mapping: multi_analyzers
  attribute :description, String, mapping: multi_analyzers

  attribute :tags, String, mapping: multi_analyzers
  attribute :machines, Array[String], mapping: { analyzer: 'standard' }

  attribute :components, Array[String], mapping: multi_analyzers
  attribute :themes, Array[String], mapping: multi_analyzers

  attribute :author, String, mapping: std_and_std_without_accent
  attribute :collaborators, Array[String], mapping: std_and_std_without_accent

  attribute :steps_body, String, mapping: multi_analyzers

  attribute :image_path, String, mapping: { index: 'not_analyzed', type: 'string' }

  validates :app_id, :project_id, presence: true

  def id
    "#{app_id}-#{project_id}"
  end
end
