module Dash::PageHelper

  # define this helper at the top of any view to setup the page
  # page("Users", nav: :admin, nav_active: :users)
  # nav: the view to load from views/nav/
  # nav_active: the active menu item to highlight
  def page(page_title, options={})
    content_for(:title) { page_title }
    @nav = options[:nav]
    @nav_active = options[:nav_active]
  end

  def page_title(default = 'Adventist Church')
    content_for?(:title) ? "#{content_for(:title)} - #{default}" : default
  end

end