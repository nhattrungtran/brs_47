module ApplicationHelper
  def full_title
    base_title = t "app.helplers.base_title"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def get_data_category
    Category.all.collect {|p| [ p.name, p.id ]}
  end
end
