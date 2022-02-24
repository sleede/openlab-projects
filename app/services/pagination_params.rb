module PaginationParams
  def self.clean(page, per_page, default_per_page: 20, max_per_page: 50)
    page = (page.present? and page.to_i > 0) ? page.to_i : 1

    per_page = if per_page.present?
      if per_page.to_i > max_per_page
        max_per_page
      else
        (per_page.to_i > 0) ? per_page.to_i : default_per_page
      end
    else
      default_per_page
    end

    return page, per_page
  end
end
