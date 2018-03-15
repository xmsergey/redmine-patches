require 'redmine_patches'
require 'overrides/queries_helper_override'
require 'overrides/query_override'

Redmine::Plugin.register 'redmine-patches' do
  name 'Redmine Patches'
  author 'BelTech'
  description 'This plugin contains fixes for Redmine.'
  version '0.0.1'
  url 'https://redmine.plansource.com/plugins/redmine-patches'
end

ActionDispatch::Callbacks.to_prepare do
  require_dependency 'overrides/redmine_tags_override' if Redmine::Plugin.installed?(:redmineup_tags) && Redmine::Plugin.find(:redmineup_tags).version == '2.0.1'
end