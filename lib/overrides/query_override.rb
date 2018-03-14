module RedminePatches
  module QueryOverride

    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        alias_method_chain :date_clause, :date_column
      end
    end

    module InstanceMethods
      DATE_TYPES = [:date].freeze

      # Generates custom where sql clause for 'date' db column type and 'from' and 'to' variables are Date class.
      # Otherwise uses native redmine core method.
      # So it doesn't consider timezone when filtered parameter is Date type in db.
      def date_clause_with_date_column(table, field, from, to, is_custom_filter)
        if (date?(from) || date?(to)) && DATE_TYPES.include?(ColumnType.for(table, field))
          s = []
          condition_pattern = "#{table}.#{field} %s '%s'"
          s << condition_pattern % ['>', end_day(from.yesterday)] if from
          s << condition_pattern % ['<=', end_day(to)] if to
          return s.join(' AND ')
        end
        date_clause_without_date_column(table, field, from, to, is_custom_filter)
      end

      private

      def date?(object)
        object.is_a?(Date)
      end

      def end_day(date)
        date.end_of_day.to_s(:db)
      end
    end
  end

  class ColumnType
    class << self
      def for(table, field)
        column(table, field).type
      end

      private

      def column(table, field)
        begin
          model(table).columns_hash[field]
        rescue
          db_connection.columns(table).select { |column| column.name == field }.first
        end
      end

      def db_connection
        ActiveRecord::Base.connection
      end

      def model(table)
        table.classify.constantize
      end
    end
  end
end

Query.send(:include, RedminePatches::QueryOverride)