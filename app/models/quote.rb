class Quote < ApplicationRecord
  has_many :line_item_dates, dependent: :destroy
  has_many :line_items, through: :line_item_dates

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

  def total_price
    line_items.sum(&:total_price)
  end
end
