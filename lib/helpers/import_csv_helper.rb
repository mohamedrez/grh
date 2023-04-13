# frozen_string_literal: true

module ImportCsvHelper
  def self.import_sites_akdital
    CSV.foreach("db/csv/sites_akdital.csv", headers: true) do |row|
      Site.create!(name: row["name"], code: row["code"], address: row["address"], phone: row["phone"])
    end
  end
end
