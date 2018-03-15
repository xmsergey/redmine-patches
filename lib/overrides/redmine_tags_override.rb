module RedminePatches
  module RedmineTagsOverride

    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        alias_method :save_tags_to_issue, :save_tags_to_issue_fixed
      end
    end

    module InstanceMethods
      # fixed history of tags changes
      def save_tags_to_issue_fixed(context, create_journal)
        params = context[:params]

        if params && params[:issue] && !params[:issue][:tag_list].nil?
          old_value = Issue.find_by(id: context[:issue].id)
          old_tags = old_value.try(:tag_list).to_s

          context[:issue].tag_list = params[:issue][:tag_list]
          new_tags = context[:issue].tag_list.to_s

          # without this when reload called in Issue#save all changes will be gone :(
          context[:issue].save_tags

          if create_journal && !(old_tags == new_tags || context[:issue].current_journal.blank?)
            context[:issue].current_journal.details << JournalDetail.new(:property => 'attr',
                                                                         :prop_key => 'tag_list',
                                                                         :old_value => old_tags,
                                                                         :value => new_tags)
          end
        end
      end
    end
  end
end

RedmineTags::Hooks::ModelIssueHook.send(:include, RedminePatches::RedmineTagsOverride)

