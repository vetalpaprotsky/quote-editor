class Quote < ApplicationRecord
  belongs_to :company

  validates :name, presence: true

  scope :ordered, -> { order(id: :desc) }

  # after_create_commit -> { broadcast_prepend_later_to [company, "quotes"], partial: "quotes/quote", locals: { quote: self }, target: "quotes" }
  # Equivalent to the above:
  after_create_commit -> { broadcast_prepend_later_to [company, "quotes"] }
  # after_update_commit -> { broadcast_replace_later_to [company, "quotes"], partial: "quotes/quote", locals: { quote: self }, target: "quote_#{id}" }
  # Equivalent to the above:
  after_update_commit -> { broadcast_replace_later_to [company, "quotes"] }
  after_destroy_commit -> { broadcast_remove_to [company, "quotes"] }

  # Above 3 callbacks can be replaced by this method.
  # broadcasts_to ->(quote) { [company, "quotes"] }, inserts_by: :prepend
end
