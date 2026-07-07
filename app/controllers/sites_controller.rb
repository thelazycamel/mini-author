class SitesController < ApplicationController
  before_action :set_site, only: [:edit, :update, :destroy]

  def index
    @sites = Site.all
  end

  def new
    @site = Site.new(
      path: "d2l/api/lr/1.0/objects",
      structure_path: "internal/api/v1/structures"
    )
  end

  def create
    @site = Site.new(site_params)
    if @site.save
      flash[:info] = "Site Created"
      redirect_to sites_path
    else
      flash.now[:error] = "Unable to create"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @site.update(site_params)
      flash[:info] = "Site Updated Successfully"
      redirect_to sites_path
    else
      flash.now[:error] = "Unable to update"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @site.destroy
      flash[:info] = "Site Destroyed Successfully"
    else
      flash[:error] = @site.errors.full_messages.join(", ")
    end
    redirect_to sites_path
  end

  private

  def set_site
    @site = Site.find(params[:id])
  end

  def site_params
    params.require(:site).permit(:name, :domain, :path, :port, :structure_path, :api_token)
  end
end
