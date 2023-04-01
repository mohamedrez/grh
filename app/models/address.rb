class Address < ApplicationRecord
  belongs_to :user
  enum :country, %i[canada cameroon france egypt germany ghana morocco usa other], prefix: :address
end
