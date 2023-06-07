class Task < ApplicationRecord
  enum status: {to_do: 0, in_progress: 1, completed: 2}
end
