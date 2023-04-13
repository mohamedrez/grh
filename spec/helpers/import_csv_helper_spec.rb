require 'rails_helper'
require "#{Rails.root}/lib/helpers/import_csv_helper.rb"

RSpec.describe ImportCsvHelper do
  describe '.import_sites_akdital' do
    let(:csv_path) { Rails.root.join('db/csv/sites_akdital.csv') }

    it 'creates sites from CSV file' do
      expect { ImportCsvHelper.import_sites_akdital }.to change(Site, :count).by(17)
    end
  end
end
