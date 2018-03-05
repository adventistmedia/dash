module Dash::TablesHelper

  def sort_header(column, title, options={})
    if params[:col] != column.to_s && options.key?(:dir)
      dir = options[:dir]
    else
      dir = params[:dir] == "DESC" ? "ASC" : "DESC"
    end
    options.delete(:dir)
    url = params.merge(col: column, dir: dir)
    active_sort = params[:col] == column.to_s
    link_title = ( title + sort_caret(active_sort, column, dir) ).html_safe
    options[:class] ||= ""
    options[:class] += " sorted" if active_sort
    content_tag :th, link_to( link_title, url.permit(:col, :dir, :page, :per, :controller, :action)), options
  end

  def sort_caret(active_sort, column, dir)
    caret = dir == "ASC" ? "up" : "down"
    active_sort ? content_tag(:span, "", class: "fa fa-angle-#{caret}") : ""
  end

  def table_paginate(scope, options={})
    return nil if scope.length.zero?
    options.reverse_merge!(change_rows: true)
    first_entry = ((scope.current_page * scope.limit_value) - (scope.limit_value - 1))
    last_entry = first_entry + (scope.length-1)
    content_tag(:div, class: "table-pagination") do
      content_tag(:div) do
        (options[:change_rows] ? content_tag(:span, "Rows per page: #{per_page_dropdown(scope)}".html_safe) : "".html_safe)  +
        content_tag(:span, "#{first_entry}-#{last_entry} of #{scope.total_count}", class: "pag-info") +
        content_tag(:span, class: "pag-links") do
          concat(link_to(content_tag(:i, "", class: "fa fa-chevron-left"), path_to_prev_page(scope), class: "pag-link pag-back")) unless scope.first_page?
          concat(link_to(content_tag(:i, "", class: "fa fa-chevron-right"), path_to_next_page(scope), class: "pag-link pag-forward")) unless scope.last_page?
        end
      end
    end
  end

  def per_page_dropdown(scope)
    max_per_options = [25, 50, 100]
    content_tag(:div, class: "dropdown per-page-dropdown") do
      link_to(scope.limit_value.to_s.html_safe + content_tag(:i, "", class: "fa fa-angle-down"), "#", class: "dropdown-toggle", data: {toggle: "dropdown"}) +
      content_tag(:div, class: "dropdown-menu dropdown-menu-right dropdown-menu-auto") do
        max_per_options.each do |per|
          concat link_to(per, request.params.merge(per: per), class: "dropdown-item")
        end
      end
    end
  end

  def dash_table(scope, options={}, &block)
    options.reverse_merge!(
      search: scope.respond_to?(:current_page),
      table_overview: scope.respond_to?(:current_page),
      table_headers: [],
      header_actions: [],
      about: true,
      partial: nil,
      table_header_actions: true,
      filters: false,
      filters_show: false,
      batch: [],
      paginate: scope.respond_to?(:current_page),
      batch_destroy_url: "#{request.path}/batch_destroy"
    )
    content_tag(:div, class: "table-features") do
      concat table_overview(options, &block) if options[:table_overview]
      concat table_filters(scope, options) if options[:filters]
      concat batch_pane(options) if options[:batch].any?
      concat table_wrapper(scope, options)
      concat table_paginate(scope) if options[:paginate]
      concat about_modal
      concat modal_batch_destroy(url: options[:batch_destroy_url]) if options[:batch].include?(:destroy)
    end
  end

  def table_overview(options, &block)
    content_tag(:div, class: "table-header #{"focus-search" if params[:q].present?}") do
      content_tag(:div, (block_given? ? capture(&block) : ""), class: "info")+
      content_tag(:div, class: "actions") do
        concat table_search if options[:search]
        concat link_to(content_tag(:i, "", class: "fa fa-filter"), "#", class: "btn-icon btn-secondary table-filters-toggle") if options[:filters]
        concat row_actions{ options[:header_actions].join.html_safe } if options[:header_actions].any?
      end
    end
  end

  def table_wrapper(scope, options)
    content_tag(:table, class: "table") do
      concat table_header(options) if options[:table_headers].any?
      concat content_tag(:tbody, render(collection: scope, partial: options[:partial], as: options[:as]), id: "table-body")
    end
  end

  def table_header(options)
    content_tag(:thead) do
      content_tag(:tr) do
        concat(bulk_selector_all) if options[:batch].present?
        options[:table_headers].each do |header|
          concat header.is_a?(Array) ? sort_header(*header) : content_tag(:th, header.to_s.titleize)
        end
        concat(content_tag(:th, "")) if options[:table_header_actions]
      end
    end
  end

  def about_modal
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

  def table_filters(scope, options={})
    return if scope.applied_filter.nil?
    active = scope.applied_filter.any? || options[:filters_show]
    content_tag(:div, class: "table-filters #{'active' if active}") do
      scope.applied_filter.filter_options.each do |_, filter|
        concat table_filter(scope.applied_filter, filter)
      end
      concat link_to("Clear", request.params.merge(filter: nil), class: "clear-filters")
    end
  end

  def table_filter(applied_filter, filter)
    active_field = applied_filter.active_field(filter[:label])
    title = active_field ? active_field[:title] : filter[:title]
    content_tag(:div, class: "dropdown") do
      link_to(title.html_safe + content_tag(:i, "", class: "fa fa-angle-down"), "#", class: "dropdown-toggle #{'active' if active_field}", data: {toggle: "dropdown"}) +
      content_tag(:div, class: "dropdown-menu dropdown-menu-icons") do
        concat link_to("#{content_tag(:i, "", class: "fa #{'fa-check' if applied_filter.field_active?(filter[:label], nil)}")}Any #{filter[:title]}".html_safe, filter_any_params(filter[:label]), class: "dropdown-item")
        filter[:fields].each do |field|
          concat link_to(content_tag(:i, "", class: "fa #{'fa-check' if applied_filter.field_active?(filter[:label], field[:value])}") + field[:title], request.params.deep_merge(filter: {filter[:label] => field[:value]}), class: "dropdown-item")
        end
      end
    end
  end

  def filter_any_params(field)
    ps = request.params.deep_dup
    ps[:filter] && ps[:filter].delete(field)
    ps
  end

  def table_search
    content_tag(:div, class: "table-search #{'active' if params[:q].present?}") do
      form_with url: url_for, method: :get, local: true do |f|
        content_tag(:div, class: "wrapper") do
          concat button_tag(content_tag(:i, "", class: "fa fa-search"), class: "search-btn")
          concat f.text_field(:q, value: params[:q], placeholder: "Search", class: "search-input", autocomplete: "off")
          concat button_tag(content_tag(:i, "", class: "fa fa-times"), class: "search-close", data: {reload: params[:q].present? ? 1 : 0 })
        end
      end
    end
  end

  def export_link(options={})
    url = request.params.merge(format: "csv").except(:page, :per)
    options.reverse_merge!(class: "dropdown-item")
    link_to(content_tag(:i, "", class: "fa fa-download") + "Export to CSV", url, options)
  end

  def row_actions(options={}, &block)
    content_tag(:div, class: "dropdown table-actions-dropdown") do
      link_to(content_tag(:i, "", class: "fa fa-ellipsis-v"), "#", class: "btn-icon btn-icon-secondary dropdown-toggle", data: {toggle: "dropdown"}) +
      content_tag(:div, capture(&block), class: "dropdown-menu dropdown-menu-right dropdown-menu-icons")
    end
  end

  def settings_actions(options={}, &block)
    content_tag(:div, class: "dropdown #{options[:dropdown_class]}") do
      link_to(content_tag(:i, "", class: "fa fa-ellipsis-v"), "#", class: "btn-icon btn-icon-secondary dropdown-toggle", data: {toggle: "dropdown"}) +
      content_tag(:div, capture(&block), class: "dropdown-menu dropdown-menu-right dropdown-menu-icons")
    end
  end

  def row_about_link(url, options={})
    options.reverse_merge!(class: "dropdown-item", data: {toggle: "modal", target: "#tableAboutModal", title: options[:title]})
    link_to(content_tag(:i, "", class: "fa fa-history") + "About", url, options)
  end

  def row_edit_link(url, options={})
    options.reverse_merge!(class: "dropdown-item")
    link_to(content_tag(:i, "", class: "fa fa-pencil") + "Edit", url, options)
  end

  def row_delete_link(url, options={})
    options.reverse_merge!(method: :delete, remote: true, class: "dropdown-item")
    link_to(content_tag(:i, "", class: "fa fa-trash") + "Delete", url, options)
  end

  def row_archive_link(url, options={})
    options.reverse_merge!(method: :delete, remote: true, class: "dropdown-item")
    link_to(content_tag(:i, "", class: "fa fa-archive") + "Archive", url, options)
  end

  def bulk_selector_all(selected = false)
    content_tag(:th, class: "bulk-selector-toggle bulk-selector-all") do
      check_box_tag("select_all", 1, selected) +
      content_tag(:i, "", class: "fa fa-square-o")
    end
  end

  def bulk_selector_item(object)
    content_tag(:td, class: "bulk-selector-toggle bulk-selector-item") do
      check_box_tag("selector", object.id, false) +
      content_tag(:i, "", class: "fa fa-square-o")
    end
  end

  def batch_pane(options={})
    options.reverse_merge!(batch: [:update, :destroy])
    actions = []
    actions << link_to(content_tag(:i, "", class: "fa fa-pencil"), "#", class: "btn-icon btn-secondary", data: {toggle: "modal", target: "#tableBatchUpdateModal"}) if options[:batch].include?(:update)
    actions << link_to(content_tag(:i, "", class: "fa fa-trash"), "#", class: "btn-icon btn-secondary", data: {toggle: "modal", target: "#tableBatchDestroyModal"}) if options[:batch].include?(:destroy)
    options[:batch].each do |item|
      if item.is_a?(String)
        actions << item
      end
    end
    actions = actions.join("")
    %{
      <div id="table-bulk-options">
        <div class="info">
          <span id="items-selected">0</span> Items Selected
        </div>
        <div class="actions">#{actions}</div>
      </div>
    }.html_safe
  end

  def modal_batch_destroy(options={}, &block)
    default_body =
      simple_form_for(:batch, url: options[:url], remote: true) do |f|
        content_tag(:p, "Please confirm you would like to delete all selected rows.") +
        f.input_field(:ids, as: :hidden, class: "batch-ids")
      end
    body = block_given? ? capture(&block) : default_body
    options.reverse_merge!(id: "tableBatchDestroyModal", title: "Delete", submit: "Delete All", submit_class: "table-batch-submit", body: body)
    modal_html(options)
  end

  def modal_batch_update(options={}, &block)
    options.reverse_merge!(id: "tableBatchUpdateModal", title: "Batch Update", submit: "Update All", submit_class: "table-batch-submit", body: capture(&block))
    modal_html(options)
  end

  def modal_html(options)
    %{
      <div class="modal fade" id="#{options[:id]}" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
          <div class="modal-content">
            <div class="modal-header modal-header-primary">
              <h5 class="modal-title">#{options[:title]}</h5>
              <button type="button" class="btn-icon btn-icon-light" data-dismiss="modal" aria-label="Close">
                <i class="fa fa-times"></i>
              </button>
            </div>
            <div class="modal-body">
              #{options[:body]}
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
              <button type="button" class="btn btn-primary #{options[:submit_class]}">#{options[:submit]}</button>
            </div>
          </div>
        </div>
      </div>
    }.html_safe
  end

end