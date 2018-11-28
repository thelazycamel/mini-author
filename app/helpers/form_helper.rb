module FormHelper

  def sites_for_select(site_id)
    options_for_select(Site.find_each.map{|site| [site.name, site.id]}, site_id)
  end

end
