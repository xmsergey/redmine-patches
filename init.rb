require 'redmine_patches'
require 'overrides/queries_helper_override'

Redmine::Plugin.register 'redmine-patches' do
  name 'Redmine Patches'
  author 'BelTech'
  description 'This plugin contains fixes for Redmine.'
  version '0.0.1'
  url 'https://redmine.plansource.com/plugins/redmine-patches'
end
