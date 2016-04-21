module Concerns::PaginationHeaders
  def set_pagination_headers(total:, page:, per_page:)
    headers['X-Total']        = total
    headers['X-Per-Page']     = per_page
    headers['X-Page']         = page
  end
end
