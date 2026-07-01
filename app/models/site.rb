class Site < ApplicationRecord
  has_many :learning_objects, dependent: :restrict_with_error
  has_many :structures, dependent: :restrict_with_error

  validates :name, presence: true
  validates :domain, presence: true

  def base_url
    uri = URI.parse(domain)
    uri.port = port.to_i if port.present?
    uri.to_s.chomp("/")
  end

  def url_for_path(path_segment)
    "#{base_url}/#{path_segment.to_s.delete_prefix("/")}"
  end
end
