class Quote < ApplicationRecord
  validates :name, presence: true

  scope :ordered, -> { order(id: :desc) }

  # after_create_commit -> { broadcast_prepend_later_to "quotes", partial: "quotes/quote", locals: { quote: self }, target: "quotes" }
  # Equivalent to the above:
  after_create_commit -> { broadcast_prepend_later_to "quotes" }
  # after_update_commit -> { broadcast_replace_later_to "quotes", partial: "quotes/quote", locals: { quote: self }, target: "quote_#{id}" }
  # Equivalent to the above:
  after_update_commit -> { broadcast_replace_later_to "quotes" }
  after_destroy_commit -> { broadcast_remove_to "quotes" }

  # Above 3 callbacks can be replaced by this method.
  # broadcasts_to ->(quote) { "quotes" }, inserts_by: :prepend
end
