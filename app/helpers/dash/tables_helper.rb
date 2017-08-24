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
        content_tag(:span, class: 'pag-links') do
          concat(link_to(content_tag(:i, '', class: 'fa fa-chevron-left'), path_to_prev_page(scope), class: 'pag-link pag-back')) unless scope.first_page?
          concat(link_to(content_tag(:i, '', class: 'fa fa-chevron-right'), path_to_next_page(scope), class: 'pag-link pag-forward')) unless scope.last_page?
        end
      end
    end
  end

  def table_about
    %{
    <div class="modal fade" id="tableAboutModal" tabindex="-1" role="dialog">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header modal-header-primary">
            <h5 class="modal-title"></h5>
            <button type="button" class="btn-icon btn-icon-light" data-dismiss="modal" aria-label="Close">
              <i class="fa fa-times"></i>
            </button>
          </div>
          <div class="modal-body">
          </div>
        </div>
      </div>
    </div>
  }.html_safe
  end

  def row_actions(options={}, &block)
    content_tag(:div, class: 'dropdown') do
      link_to(content_tag(:i, '', class: 'fa fa-ellipsis-v'), '#', class: 'btn-icon btn-icon-secondary dropdown-toggle', data: {toggle: 'dropdown'}) +
      content_tag(:div, capture(&block), class: 'dropdown-menu dropdown-menu-right dropdown-menu-icons')
    end
  end

  def row_about_link(url, options={})
    link_to(content_tag(:i, '', class: 'fa fa-history') + 'About', url, class: 'dropdown-item', data: {toggle: 'modal', target: '#tableAboutModal', title: options[:title]})
  end

  def row_edit_link(url, options={})
    options.reverse_merge!(method: :get, remote: false)
    link_to(content_tag(:i, '', class: 'fa fa-pencil') + 'Edit', url, class: 'dropdown-item', data: options[:data], method: options[:method])
  end

  def row_delete_link(url, options={})
    options.reverse_merge!(method: :delete, remote: true)
    link_to(content_tag(:i, '', class: 'fa fa-trash') + 'Delete', url, class: 'dropdown-item', data: options[:data], method: options[:method])
  end

  def bulk_selector_all(selected = false)
    content_tag(:th, class: 'bulk-selector-toggle bulk-selector-all') do
      check_box_tag('select_all', 1, selected) +
      content_tag(:i, '', class: 'fa fa-square-o')
    end
  end

  def bulk_selector_item(object)
    content_tag(:td, class: 'bulk-selector-toggle bulk-selector-item') do
      check_box_tag('selector', object.id, false) +
      content_tag(:i, '', class: 'fa fa-square-o')
    end
  end

end