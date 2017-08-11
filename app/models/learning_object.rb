class LearningObject < ActiveRecord::Base

  mount_uploader :lo
  mount_uploader :info_xml

  belongs_to :site

end
