module Admin::Resources::PaginationHelper

  def admin_paginate(items, options)
    if defined?(Kaminari)
      paginate(items, **options)
    elsif defined?(WillPaginate)
      will_paginate(items, options.dup)
    else
      typus_paginate(items, options.dup)
    end
  end

  # TODO: Quick and dirty pagination solution! We only want to go back and
  # forward, so it will be simple.
  def typus_paginate(items, options)
    render "admin/resources/pagination"
  end

end
