module Dash::Searchable
  extend ActiveSupport::Concern

  included do
    class_attribute :search_fields
  end

  module ClassMethods

    def search(term = '', options={})
      options.reverse_merge!(fuzzy: false, profile: :default)
      if term.blank?
        all
      else
        query =
        if options[:fuzzy]
          fuzy_search_conditions(term, options)
        else
          basic_search_conditions(term, options)
        end
        join_tables = search_fields[options[:profile]].keys - [table_name.to_sym]
        if join_tables.any?
          query = query.joins(join_tables).distinct
        end
        query
      end
    end

    def basic_search_conditions(term, options)
      search_conditions("%#{term}%", "ILIKE ?", options)
    end

    def fuzy_search_conditions(term, options)
      ActiveRecord::Base.connection.execute("SELECT set_limit(0.2);")
      rank = connection.quote_column_name('rank' + rand(100000000000000000).to_s)
      query = search_conditions(term, "% ?", options)
      query = query.select("#{quoted_table_name + '.*,' if all.select_values.empty?} #{search_similarities_select(term, options).join(" + ")} AS #{rank}")
      query = query.order("#{rank} DESC")
    end

    def search_conditions(term, joiner, options)
      condition_query = []
      search_fields[options[:profile]].each do |table, search_columns|
        table_name = connection.quote_table_name(table.to_s.pluralize)
        search_columns.each do |search_column|
          column = connection.quote_column_name(search_column)
          condition_query << "#{table_name}.#{column} #{joiner}"
        end
      end
      where(condition_query.join(' OR '), *Array.new(condition_query.length, term))
    end

    def search_similarities_select(term, options)
      similarity_term = ActiveRecord::Base.connection.quote(term)
      similiarity_query = []
      search_fields[options[:profile]].each do |table, search_columns|
        table_name = connection.quote_table_name(table.to_s.pluralize)
        search_columns.each do |search_column|
          column = connection.quote_column_name(search_column)
          similiarity_query << "COALESCE(similarity(#{table_name}.#{column}, #{similarity_term}), 0)"
        end
      end
      similiarity_query
    end

    # takes either an array of column names where the table is the current models table
    # searchable on: :name
    # or a hash with table names as keys and array of columns as values
    # searchable in: :team, on: [:status]
    # Note: on should be singular
    def searchable(options={})
      self.search_fields ||= {}
      profile = options[:profile] || :default
      options[:in] ||= table_name.to_sym
      self.search_fields[profile] ||= {}
      self.search_fields[profile].merge!( options[:in] => Array.wrap(options[:on]) )
    end
  end

end