require 'rails_helper'

RSpec.describe Expense, type: :model do
  let(:manager_user) { create(:user) }
  let(:user) { create(:user, manager_id: manager_user.id) }
  let(:expense) { create(:expense, user_id: user.id) }

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
end
