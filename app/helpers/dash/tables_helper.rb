module Dash::TablesHelper

  def sort_header(column, title, options={})
    if params[:col] != column.to_s && options.key?(:dir)
      dir = options[:dir]
    else
      dir = params[:dir] == 'DESC' ? 'ASC' : 'DESC'
    end
    options.delete(:dir)
    url = params.merge(col: column, dir: dir)
    active_sort = params[:col] == column.to_s
    link_title = ( title + sort_caret(active_sort, column, dir) ).html_safe
    options[:class] ||= ''
    options[:class] += ' sorted' if active_sort
    content_tag :th, link_to( link_title, url.permit(:col, :dir, :page, :controller, :action)), options
  end

  def sort_caret(active_sort, column, dir)
    caret = dir == 'ASC' ? 'up' : 'down'
    active_sort ? content_tag(:span, '', class: "fa fa-angle-#{caret}") : ''
  end

  def table_paginate(scope, options={})
    return nil if scope.length.zero?
    first_entry = ((scope.current_page * scope.limit_value) - (scope.limit_value - 1))
    last_entry = first_entry + (scope.length-1)
    content_tag(:div, class: 'table-pagination') do
      content_tag(:div) do
        content_tag(:span, "#{first_entry}-#{last_entry} of #{scope.total_count}", class: 'pag-info') +
        link_to(content_tag(:i, '', class: 'fa fa-chevron-left'), '#', class: 'pag-link pag-back') +
        link_to(content_tag(:i, '', class: 'fa fa-chevron-right'), '#', class: 'pag-link pag-forward')
      end
    end
  end

  def row_actions(options={}, &block)
    capture(&block)
  end

end