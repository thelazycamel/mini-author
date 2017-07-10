class LearningObject < ActiveRecord::Base

  mount_uploader :lo

  belongs_to :site

end
