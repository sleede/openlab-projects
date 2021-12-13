# frozen_string_literal: true

module ElasticConfig
  def self.settings
    {
      index: {
        number_of_shards: Rails.env.test? ? 1 : 5,
        number_of_replicas: 0,
        refresh_interval: '1s' # default value
      },
      analysis: {
        filter: {
          "french_elision": {
            "type": 'elision',
            "articles": %w[l m t qu n s j d c jusqu quoiqu lorsqu puisqu]
          },
          "french_stop": {
            "type": 'stop',
            "stopwords": '_french_'
          },
          "french_stemmer": {
            "type": 'stemmer',
            "language": 'light_french'
          }
        },
        analyzer: {
          "french_without_accent": {
            "tokenizer": 'standard',
            "filter": %w[asciifolding french_elision lowercase french_stop french_stemmer]
          },
          "standard_without_accent": {
            tokenizer: 'standard',
            filter: %w[asciifolding lowercase]
          }
        }
      }
    }
  end

  def self.mappings
    {
      dynamic: 'strict'
    }
  end
end
