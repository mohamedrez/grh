require "csv"

class Site < ApplicationRecord
  has_one :user, dependent: :destroy

  def self.import_csv_data
    CSV.foreach("db/csv/sites_akdital.csv", headers: true) do |row|
      Site.create!(name: row["name"], code: row["code"], address: row["address"], phone: row["phone"])
    end
  end
end
