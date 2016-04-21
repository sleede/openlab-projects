class PaginationMeta
  attr_accessor :total, :page, :per_page

  def initialize(total:, page:, per_page:)
    @total, @page, @per_page = total, page, per_page
  end

  def to_hash
    { meta: {
        page: page,
        per_page: per_page,
        total: total
      }
    }
  end
end
