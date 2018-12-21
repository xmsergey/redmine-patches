module RedminePatches
  module TimeEntryOverride

    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        alias_method_chain :editable_by?, :fix
        alias_method_chain :validate_time_entry, :fix
      end
    end

    module InstanceMethods
      # Returns true if the time entry can be edited by usr, otherwise false
      def editable_by_with_fix?(usr)
        return false unless editable_by_without_fix?(usr)

        log_time_entry_period = time_entry_edit_period(usr)

        return true unless log_time_entry_period > 0

        (spent_on + log_time_entry_period) > Date.today
      end

      def validate_time_entry_with_fix
        validate_time_entry_without_fix
        validate_user = User.current
        errors.add :base, :changes_are_restricted_for_that_date, date: spent_on if validate_user.present? && !editable_by_with_fix?(validate_user)
      end

      def time_entry_edit_period(usr)
        user_groups = usr.groups.to_a
        return 0 unless user_groups.present?

        log_time_entry_period = 0
        user_groups.each do |group|
          first_period = group.custom_field_values.select { |value| value.custom_field.name == 'LogTime Edit Period' }.first
          group_log_time_entry_period = first_period && first_period.value && first_period.value.to_i
          log_time_entry_period = [log_time_entry_period, group_log_time_entry_period].max
        end
        log_time_entry_period || 0
      end
    end
  end
end

TimeEntry.send(:include, RedminePatches::TimeEntryOverride)
