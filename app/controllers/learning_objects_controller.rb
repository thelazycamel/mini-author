class LearningObjectsController < ApplicationController
  before_action :set_learning_object, only: [:edit, :update, :destroy]

  def index
    @learning_objects = LearningObject.includes(:site).all
  end

  def new
    @learning_object = LearningObject.new
  end

  def create
    @learning_object = LearningObject.new(learning_object_params)
    CreateOrUpdateLearningObjectCommand.execute(@learning_object)
    flash[:info] = "Created Successfully"
    redirect_to learning_objects_path
  rescue => e
    flash.now[:danger] = "Something went wrong: #{e.message}"
    render :new, status: :unprocessable_entity
  end

  def edit
  end

  def update
    CreateOrUpdateLearningObjectCommand.execute(@learning_object, learning_object_params)
    flash[:info] = "Updated Successfully"
    redirect_to learning_objects_path
  rescue => e
    flash.now[:danger] = "Something went wrong: #{e.message}"
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @learning_object.destroy
    flash[:info] = "Learning Object Destroyed Successfully"
    redirect_to learning_objects_path
  end

  private

  def set_learning_object
    @learning_object = LearningObject.find(params[:id])
  end

  def learning_object_params
    params.require(:learning_object).permit(:name, :site_id, :lo, :info_xml)
  end
end
