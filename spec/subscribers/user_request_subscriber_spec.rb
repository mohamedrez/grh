require 'rails_helper'

RSpec.describe UserRequestSubscriber, type: :model do
  let(:site) { create(:site) }
  let(:manager) { create(:user) }
  let(:user) { create(:user, manager_id: manager.id, site_id: site.id) }

  describe '#after_create' do
    it 'sends an email to the manager' do
      create(:mission_order, user_id: user.id, site_id: site.id, start_date: "2023-06-08", end_date: "2023-06-08", indemnity_type: "expense_report", aasm_state: "created").user_request

      expect(ActionMailer::Base.deliveries.last.to.first).to eq(manager.email)
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end

  describe '#notify_owner' do
    it 'sends an email to the manager' do
      user_request = create(:mission_order, user_id: user.id, site_id: site.id, start_date: "2023-06-08", end_date: "2023-06-08", indemnity_type: "expense_report", aasm_state: "created").user_request
      ActionMailer::Base.deliveries.clear

      user_request.requestable.reject!

      expect(ActionMailer::Base.deliveries.last.to.first).to eq(user.email)
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end

  describe '#notify_hr_site_manager' do
    it 'sends an email to the HR site manager' do
      user_request = create(:mission_order, user_id: user.id, site_id: site.id, start_date: "2023-06-08", end_date: "2023-06-08", indemnity_type: "expense_report", aasm_state: "validated_by_manager").user_request
      ActionMailer::Base.deliveries.clear

      hr_site_manager = create(:user, site_id: site.id)
      Role.create!(name: :hr_site_manager, user_id: hr_site_manager.id)

      user_request.requestable.validate_by_hr!
  
      expect(user_request.user.site.name).to eq(site.name)
      expect(site.roles.where(name: "hr_site_manager").count).to eq(1)
      expect(site.roles.find_by(name: "hr_site_manager")).to eq(Role.last)
      expect(site.roles.find_by(name: "hr_site_manager").user.email).to eq(hr_site_manager.email)
    end
  end

  describe '#notify_accountant_site_manager' do
    context "mission order of type 'site'" do
      it "sends an email to the Accountant site manager" do
        mission_order = create(:mission_order, user_id: user.id, site_id: site.id, start_date: "2023-06-08", end_date: "2023-06-08", indemnity_type: "expense_report", aasm_state: "validated_by_hr", mission_type: "site")
        user_request = mission_order.user_request
        ActionMailer::Base.deliveries.clear

        accountant_site_manager = create(:user, site_id: site.id)
        Role.create!(name: :accountant_site_manager, user_id: accountant_site_manager.id)

        mission_order.pay_by_accountant!

        expect(user_request.user.site.name).to eq(site.name)
        expect(site.roles.where(name: "accountant_site_manager").count).to eq(1)
        expect(site.roles.find_by(name: "accountant_site_manager")).to eq(Role.last)
        expect(site.roles.find_by(name: "accountant_site_manager").user.email).to eq(accountant_site_manager.email)
      end
    end

    context "mission order of type 'project'" do
      it "sends an email to the Holding treasury manager" do
        mission_order = create(:mission_order, user_id: user.id, site_id: site.id, start_date: "2023-06-08", end_date: "2023-06-08", indemnity_type: "expense_report", aasm_state: "validated_by_hr", mission_type: "project")
        user_request = mission_order.user_request
        ActionMailer::Base.deliveries.clear

        holding_treasury_manager = create(:user, site_id: site.id)
        Role.create!(name: :holding_treasury_manager, user_id: holding_treasury_manager.id)

        mission_order.pay_by_accountant!

        expect(user_request.user.site.name).to eq(site.name)
        expect(site.roles.where(name: "holding_treasury_manager").count).to eq(1)
        expect(site.roles.find_by(name: "holding_treasury_manager")).to eq(Role.last)
        expect(site.roles.find_by(name: "holding_treasury_manager").user.email).to eq(holding_treasury_manager.email)
      end
    end
  end
end