class RedminePatchesHookListener < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context={})
    stylesheet_link_tag('redmine_patches', plugin: 'redmine-patches')
  end
end
