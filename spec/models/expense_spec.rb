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

    it 'returns the correct next states for aasm_state with value validated_by_manager' do
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

      expense.update!(aasm_state: "validated_by_hr")

      next_states = expense.available_next_states(user_multi_roles)
      expect(next_states).to eq([:pay, :back_to_modify])
    end
  end

end
