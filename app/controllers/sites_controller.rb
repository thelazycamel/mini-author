class SitesController < ApplicationController

  def index
    @sites = Site.all
  end

  def new
    @site = Site.new
  end

  def create
    @site = Site.new(site_params)
    if @site.save
      flash[:info] = "Site Created"
      redirect_to sites_path
    else
      flash.now[:error] = "Unable to create"
      render :new
    end
  end

  def edit
    @site = Site.find(params[:id])
  end

  def update
    @site = Site.find(params[:id])
    @site.update_attributes(site_params)
    flash[:info] = "Site Updated Successfully"
    redirect_to sites_path
  end

  def destroy
    @site = Site.find(params[:id])
    @site.destroy
    flash[:info] = "Site Destroyed Successfully"
    redirect_to sites_path
  end

  private

  def site_params
    params.require(:site).permit(:name, :domain, :path, :port)
  end

end
