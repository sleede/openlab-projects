# frozen_string_literal: true

module Concerns::Elasticable
  extend ActiveSupport::Concern

  included do
    index_name [Rails.application.secrets.elasticsearch_index_name, Rails.env].join('_')
  end
end
