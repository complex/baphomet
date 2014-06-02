class Payment < ActiveRecord::Base

  attr_accessor :to, :number, :expiration

  validates_presence_of :amount, message: "You must specify an amount."
  validates_numericality_of :amount, greater_than_or_equal_to: 1, message: "Amount must be at least $1."
  validates_presence_of :card_token, message: "There was a problem communicating with the card processor. Please try again in a minute."

  before_create :charge

  def charge
    charge = Stripe::Charge.create(
      currency: 'usd',
      amount: (self.amount * 100).to_i,
      card: self.card_token,
      metadata: {
        from: self.from,
        note: self.note
      }
    )
    self.charge_token = charge.id
  rescue => error
    self.errors.add :base, "There was a problem charging your card."
    return false
  end

end
