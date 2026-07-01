class CreateOrUpdateStructureCommand < BaseCommand
  attr_reader :structure, :params

  def initialize(structure, params = {})
    @structure = structure
    @params = params
  end

  def execute
    structure.assign_attributes(params) if params.present?
    structure.course_id = nil if structure.course_id.blank?
    structure.save!
    upload_to_importer
    structure.save!
  end

  private

  def upload_to_importer
    payload = {
      data: {
        type: "structures",
        attributes: {
          name: structure.name,
          structure_xml_url: structure_xml_url,
          cover_image_url: structure.cover_image_url.presence
        }.compact,
        links: {
          callback: "#{ENV.fetch("LOCAL_AUTHOR_URL", "http://local_author:8084")}/structures"
        }
      }
    }

    if structure.course_id.present?
      payload[:data][:id] = structure.course_id
      response = RestClient.put(
        "#{importer_structures_url}/#{structure.course_id}",
        payload.to_json,
        request_headers
      )
    else
      response = RestClient.post(
        importer_structures_url,
        payload.to_json,
        request_headers
      )
    end

    parsed = JSON.parse(response.body)
    structure.course_id ||= parsed.dig("data", "id")
    structure.upload_response = parsed.dig("data", "id")
  end

  def structure_xml_url
    base = ENV.fetch("LOCAL_AUTHOR_URL", "http://local_author:8084")
    "#{base}#{structure.structure_xml.url}"
  end

  def importer_structures_url
    structure.site.url_for_path(structure.site.structure_path)
  end

  def request_headers
    headers = { content_type: "application/vnd.api+json", accept: "application/vnd.api+json" }
    headers[:Authorization] = "Bearer #{structure.site.api_token}" if structure.site.api_token.present?
    headers
  end
end
