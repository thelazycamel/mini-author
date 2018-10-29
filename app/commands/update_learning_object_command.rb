class UpdateLearningObjectCommand < BaseCommand

  attr_reader :learning_object, :lo_params

  def initialize(learning_object, lo_params)
    @learning_object = learning_object
    @lo_params = lo_params
  end

  def execute
    add_new_file if lo_params[:lo]
    upload_to_site
    update_learning_object
  end

  private

  def add_new_file
    learning_object.update_attribute(:lo, lo_params[:lo])
  end

  def upload_to_site
    upload_response = RestClient.post(resource_url, {"Resource" => lo_file, "LearningObjectInfo" => info_xml_file}, {content_type: :json, accept: :json})
    @identifier = upload_response = JSON.parse(upload_response)["IdentId"]
  end

  def update_learning_object
    learning_object.update_attributes(lo_params.merge(upload_response: @identifier))
  end

  def info_xml_file
    File.new(learning_object.info_xml.file.file) if learning_object.info_xml
  end

  def lo_file
    File.new(learning_object.lo.file.file)
  end

  def resource_url
    "#{resource_domain}:#{resource_port}#{resource_path}/#{identifier}"
  end

  def identifier
    learning_object.upload_response
  end

  def resource_domain
    learning_object.site.domain
  end

  def resource_port
    learning_object.site.port ? learning_object.site.port.to_i : 80
  end

  def resource_path
    learning_object.site.path
  end

end
