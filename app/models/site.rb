class Site < ApplicationRecord
  belongs_to :user
  enum :name, %i[CCAB CIOC CJO HPC CMCL VINCI], prefix: :user
end
