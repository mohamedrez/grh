require 'rails_helper'

RSpec.describe ExpensePolicy do
  describe "relation scope" do
    let(:admin_user) { create(:user) }
    let(:hr_user) { create(:user) }
    let(:manager_user) { create(:user) }
    let(:user) { create(:user, manager_id: manager_user.id) }
    let(:other_user) { create(:user) }

    let(:target) { Expense.all }

    before do
      Role.create!(user_id: admin_user.id, name: :admin)
      Role.create!(user_id: hr_user.id, name: :hr)

      expenses = [
        create(:expense, id: 1, user_id: user.id),
        create(:expense, id: 2, user_id: user.id),
        create(:expense, id: 3, user_id: other_user.id)
      ]
    end    

    context "Admin will get all the Expenses" do
      let(:policy) { described_class.new(user: admin_user, target: target) }
      subject { policy.apply_scope(target, type: :active_record_relation).count }

      it { is_expected.to eq(3) }
    end

    context "HR will get all the Expenses" do
      let(:policy) { described_class.new(user: hr_user, target: target) }
      subject { policy.apply_scope(target, type: :active_record_relation).count }

      it { is_expected.to eq(3) }
    end

    context "Manger will gets Expenses of his team" do
      let(:policy) { described_class.new(user: manager_user, target: target) }
      subject { policy.apply_scope(target, type: :active_record_relation).count }

      it { is_expected.to eq(2) }
    end
  end
end
