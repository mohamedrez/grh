class MissionOrder < ApplicationRecord
  belongs_to :site
  has_rich_text :description
end
