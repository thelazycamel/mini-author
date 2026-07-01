class Structure < ApplicationRecord
  belongs_to :site

  mount_uploader :structure_xml, StructureXmlUploader

  validates :name, presence: true, length: { maximum: 255 }
  validates :site, presence: true
  validates :structure_xml, presence: true
end
