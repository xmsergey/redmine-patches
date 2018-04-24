module RedminePatches
  module ApplicationHelperOverride

    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        alias_method_chain :javascript_heads, :select2
      end
    end

    module InstanceMethods
      # Returns the javascript tags that are included in the html layout head
      def javascript_heads_with_select2
        tags = javascript_heads_without_select2
        tags << select2_assets
        tags
      end
    end

  end
end

ApplicationHelper.send(:include, RedminePatches::ApplicationHelperOverride)