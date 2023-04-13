require 'rails_helper'

RSpec.describe Site, type: :model do
  describe ".import_csv_data" do
    it 'imports all records from CSV file' do
      expect { Site.import_csv_data }.to change(Site, :count).by(17)
    end
  end
end
