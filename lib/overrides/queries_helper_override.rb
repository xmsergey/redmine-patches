module RedminePatches
  module QueriesHelperOverride

    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        alias_method_chain :csv_value, :tags
      end
    end

    module InstanceMethods
      # add case for ':tags' column
      def csv_value_with_tags(column, object, value)
        column.name == :tags ?  value.to_a.compact.uniq.map(&:name).join(', ') : csv_value_without_tags(column, object, value)
      end
    end
  end
end

QueriesHelper.send(:include, RedminePatches::QueriesHelperOverride)
