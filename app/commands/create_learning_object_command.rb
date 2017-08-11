class CreateLearningObjectCommand < BaseCommand

  attr_reader :learning_object

  def initialize(learning_object)
    @learning_object = learning_object
  end

  def execute
    upload_to_site
    save_learning_object
  end

  private

  def upload_to_site
    upload_response = RestClient.put(resource_url, {"Resource" => lo_file, "LearningObjectInfo" => info_xml_file}, {content_type: :json, accept: :json})
    learning_object.upload_response = JSON.parse(upload_response)["IdentId"]
  end

  def save_learning_object
    learning_object.save!
  end

  def info_xml_file
    File.new(learning_object.info_xml.file.file) if learning_object.info_xml
  end

  def lo_file
    File.new(learning_object.lo.file.file)
  end

  def resource_url
    "#{resource_domain}:#{resource_port}#{resource_path}"
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
