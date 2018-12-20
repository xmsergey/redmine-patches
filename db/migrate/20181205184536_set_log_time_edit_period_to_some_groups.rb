class SetLogTimeEditPeriodToSomeGroups < ActiveRecord::Migration

  LOG_TIME_EDIT_PERIOD_CUSTOM_FIELD_NAME = 'LogTime Edit Period'.freeze
  GROUP_NAMES = ['BelTech Belarus IPUs', 'BelTech Belarus CH', 'BelTech QA'].freeze

  def up
    custom_field = GroupCustomField.where(name: LOG_TIME_EDIT_PERIOD_CUSTOM_FIELD_NAME).first
    if custom_field.present?
      GROUP_NAMES.each do |group_name|
        if group = Group.named(group_name).first
          if target = group.custom_values.detect {|cv| cv.custom_field == custom_field}
            target.value = '7'
            target.save
          else
            v = CustomValue.new :custom_field_id => custom_field.id,
                                :value => '7'
            v.customized = group
            v.save
          end
        end
      end
    end
  end

  def down
    custom_field = GroupCustomField.where(name: LOG_TIME_EDIT_PERIOD_CUSTOM_FIELD_NAME).first
    if custom_field.present?
      GROUP_NAMES.each do |group_name|
        if group = Group.named(group_name).first
          if target = group.custom_values.detect {|cv| cv.custom_field == custom_field}
            target.destroy
          end
        end
      end
    end
  end
end
