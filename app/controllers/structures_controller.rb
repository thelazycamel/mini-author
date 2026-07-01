class StructuresController < ApplicationController
  before_action :set_structure, only: [:edit, :update, :destroy]

  def index
    @structures = Structure.includes(:site).all
  end

  def new
    @structure = Structure.new
  end

  def create
    @structure = Structure.new(structure_params)
    CreateOrUpdateStructureCommand.execute(@structure)
    flash[:info] = "Structure Created Successfully"
    redirect_to structures_path
  rescue RestClient::ExceptionWithResponse => e
    Rails.logger.error("Structure create failed: #{e.class} - #{e.message}")
    Rails.logger.error("Response body: #{e.response&.body}")
    Rails.logger.error(e.backtrace&.first(5)&.join("\n"))
    flash.now[:danger] = "Upload failed (#{e.response&.code}): #{e.response&.body&.truncate(200)}"
    render :new, status: :unprocessable_entity
  rescue => e
    Rails.logger.error("Structure create failed: #{e.class} - #{e.message}")
    Rails.logger.error(e.backtrace&.first(10)&.join("\n"))
    flash.now[:danger] = "Something went wrong: #{e.message}"
    render :new, status: :unprocessable_entity
  end

  def edit
  end

  def update
    CreateOrUpdateStructureCommand.execute(@structure, structure_params)
    flash[:info] = "Structure Updated Successfully"
    redirect_to structures_path
  rescue RestClient::ExceptionWithResponse => e
    Rails.logger.error("Structure update failed: #{e.class} - #{e.message}")
    Rails.logger.error("Response body: #{e.response&.body}")
    Rails.logger.error(e.backtrace&.first(5)&.join("\n"))
    flash.now[:danger] = "Upload failed (#{e.response&.code}): #{e.response&.body&.truncate(200)}"
    render :edit, status: :unprocessable_entity
  rescue => e
    Rails.logger.error("Structure update failed: #{e.class} - #{e.message}")
    Rails.logger.error(e.backtrace&.first(10)&.join("\n"))
    flash.now[:danger] = "Something went wrong: #{e.message}"
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @structure.destroy
    flash[:info] = "Structure Destroyed Successfully"
    redirect_to structures_path
  end

  private

  def set_structure
    @structure = Structure.find(params[:id])
  end

  def structure_params
    params.require(:structure).permit(:name, :site_id, :structure_xml, :course_id, :cover_image_url)
  end
end
