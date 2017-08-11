class LearningObjectsController < ApplicationController

  def index
    @learning_objects = LearningObject.all
  end

  def new
    @learning_object = LearningObject.new
  end

  def create
    @learning_object = LearningObject.new(learning_object_params)
    CreateLearningObjectCommand.execute(@learning_object)
    flash[:info] = "Created Successfully"
    redirect_to learning_objects_path
  rescue
    flash.now[:danger] = "Something went wrong, check the logs"
    render :new
  end

  def edit
    @learning_object = LearningObject.find(params[:id])
  end

  def update
    @learning_object = LearningObject.find(params[:id])
    UpdateLearningObjectCommand.execute(@learning_object, learning_object_params)
    flash[:info] = "Updated successfully"
    redirect_to learning_objects_path
  rescue
    flash.now[:danger] = "Something went wrong, check the logs"
    render :edit
  end

  def destroy
    @learning_object = LearningObject.find(params[:id])
    @learning_object.destroy
    flash[:info] = "Learning Object Destroyed Successfully"
    redirect_to learning_objects_path
  end

  private

  def learning_object_params
    params.require(:learning_object).permit(:name, :site_id, :lo, :info_xml)
  end

end
