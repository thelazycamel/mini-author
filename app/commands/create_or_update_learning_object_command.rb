class CreateOrUpdateLearningObjectCommand < BaseCommand
  attr_reader :learning_object, :params

  def initialize(learning_object, params = {})
    @learning_object = learning_object
    @params = params
  end

  def execute
    learning_object.assign_attributes(params) if params.present?
    upload_to_site
    learning_object.save!
  end

  private

  def upload_to_site
    payload = { "Resource" => lo_file }
    payload["LearningObjectInfo"] = info_xml_file if learning_object.info_xml.present?

    response = RestClient.put(resource_url, payload, { accept: :json })
    learning_object.upload_response = JSON.parse(response.body)["IdentId"]
  end

  def lo_file
    File.new(learning_object.lo.file.file)
  end

  def info_xml_file
    File.new(learning_object.info_xml.file.file)
  end

  def resource_url
    learning_object.site.url_for_path(learning_object.site.path)
  end
end
