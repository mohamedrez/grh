require 'rails_helper'

RSpec.describe Expense, type: :model do
  let(:manager_user) { create(:user) }
  let(:user) { create(:user, manager_id: manager_user.id) }
  let(:expense) { create(:expense, user_id: user.id) }

  describe "#color?" do
    it "returns 'gray' for aasm_state with value created" do
      expect(expense.color).to eq("gray")
    end

    it "returns 'indigo' for aasm_state with value validated_by_manager" do
      expense.update!(aasm_state: "validated_by_manager")
      expect(expense.color).to eq("indigo")
    end

    it "returns 'indigo' for aasm_state with value validated_by_hr" do
      expense.update!(aasm_state: "validated_by_hr")
      expect(expense.color).to eq("indigo")
    end

    it "returns 'green' for aasm_state with value paid" do
      expense.update!(aasm_state: "paid")
      expect(expense.color).to eq("green")
    end

    it "returns 'yellow' for aasm_state with value back_to_modified" do
      expense.update!(aasm_state: "back_to_modified")
      expect(expense.color).to eq("yellow")
    end

    it "returns 'red' for aasm_state with value rejected" do
      expense.update!(aasm_state: "rejected")
      expect(expense.color).to eq("red")
    end
  end

  describe '#available_next_states' do
    it 'returns the correct next states for aasm_state with value created' do
      Role.create!(user_id: manager_user.id, name: :manager)

      next_states = expense.available_next_states(manager_user)
      expect(next_states).to eq([:validate_by_manager, :back_to_modify, :reject])
    end

    it 'returns the correct next states for aasm_state with value validated_by_manager' do
      hr_user = create(:user)
      Role.create!(user_id: hr_user.id, name: :hr)
      expense.update!(aasm_state: "validated_by_manager")

      next_states = expense.available_next_states(hr_user)
      expect(next_states).to eq([:validate_by_hr, :back_to_modify, :reject])
    end

    it 'returns the correct next states for aasm_state with value validated_by_hr' do
      accountant_user = create(:user)
      Role.create!(user_id: accountant_user.id, name: :accountant)
      expense.update!(aasm_state: "validated_by_hr")

      next_states = expense.available_next_states(accountant_user)
      expect(next_states).to eq([:pay, :back_to_modify])
    end

    it 'returns the correct next states for aasm_state with value back_to_modified' do
      user_multi_roles = create(:user)

      Role.create!(user_id: user_multi_roles.id, name: :manager)
      Role.create!(user_id: user_multi_roles.id, name: :hr)
      Role.create!(user_id: user_multi_roles.id, name: :accountant)

      expense.update!(aasm_state: "back_to_modified")

      next_states = expense.available_next_states(user_multi_roles)
      expect(next_states).to eq([:validate_by_manager, :back_to_modify, :reject])
    end

    it 'returns an [] for unsupported states' do
      expense.aasm_state = 'paid'
      next_states = expense.available_next_states(user)
      expect(next_states).to be_empty
    end
  end

  describe '#update_to_next_state' do
    it 'updates the state to validated_by_manager' do
      expense.update_to_next_state("validate_by_manager")
      expect(expense.aasm_state).to eq("validated_by_manager")
    end

    it 'updates the state to validated_by_hr' do
      expense.aasm_state = "validated_by_manager"

      expense.update_to_next_state("validate_by_hr")
      expect(expense.aasm_state).to eq("validated_by_hr")
    end

    it 'updates the state to paid' do
      expense.aasm_state = "validated_by_hr"

      expense.update_to_next_state("pay")
      expect(expense.aasm_state).to eq("paid")
    end

    it 'updates the state to back_to_modified' do
      expense.update_to_next_state("back_to_modify")
      expect(expense.aasm_state).to eq("back_to_modified")
    end

    it 'updates the state to rejected' do
      expense.update_to_next_state("reject")
      expect(expense.aasm_state).to eq("rejected")
    end
  end
end
