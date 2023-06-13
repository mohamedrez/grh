class AasmLog < ApplicationRecord
  belongs_to :actor, class_name: "User"
  belongs_to :aasm_logable, polymorphic: true
end
