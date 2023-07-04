class MultipleSelectOption < ApplicationRecord
  belongs_to :multiple_select_response
  belongs_to :option
end
