class AddLogTimeEditPeriodToCustomFields < ActiveRecord::Migration

  LOG_TIME_EDIT_PERIOD_CUSTOM_FIELD_NAME = 'LogTime Edit Period'.freeze

  def up
    return if GroupCustomField.exists?(name: LOG_TIME_EDIT_PERIOD_CUSTOM_FIELD_NAME)

    GroupCustomField.create!(
      name: LOG_TIME_EDIT_PERIOD_CUSTOM_FIELD_NAME,
      field_format: 'int',
      min_length: 1,
      max_length: 365,
      is_required: 0,
      is_for_all: 0,
      is_filter: 0,
      position: 1,
      default_value: '0',
      editable: 1,
      visible: 1,
      description: "If the TimeLog is aged more than [value] days then it's modification will be prohibited"
    )
  end

  def down
    custom_field = GroupCustomField.where(name: LOG_TIME_EDIT_PERIOD_CUSTOM_FIELD_NAME).first
    custom_field.destroy if custom_field.present?
  end
end
