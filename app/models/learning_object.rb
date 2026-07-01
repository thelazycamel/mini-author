class LearningObject < ApplicationRecord
  belongs_to :site

  mount_uploader :lo, LoUploader
  mount_uploader :info_xml, InfoXmlUploader

  validates :name, presence: true, length: { maximum: 255 }
  validates :site, presence: true
  validates :lo, presence: true
end
