# frozen_string_literal: true

class Project < ActiveRecord::Base
  include PgSearch::Model

  belongs_to :api_client, inverse_of: :projects

  # validations
  validates :name, :project_id, :project_path, presence: true

  pg_search_scope :search,
    against: :search_vector,
    using: {
      tsearch: {
        dictionary: Rails.application.secrets.postgresql_language_analyzer,
        prefix: true,
        tsvector_column: 'search_vector'
      },
      trigram: {
        word_similarity: true,
        threshold: 0.3
      },
      dmetaphone: {}
    },
    ignoring: :accents,
    order_within_rank: 'created_at DESC'
end
