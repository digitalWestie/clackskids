class Issue < ActiveRecord::Base

  validates :service_id, presence: true
  validates :reason, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  extend Enumerize
  enumerize :reason, in: [:outdated, :innacurate]

  after_create :set_activation

  def keep_relevant(service)
    if self.still_relevant?(service)
      return true
    else
      self.destroy
      return false
    end
  end

  def still_relevant?(service)
    service.updated_at.to_i.to_s.eql?(self.service_timestamp)
  end

  private

  def set_activation
    self.update_attribute(:activation, SecureRandom.uuid)
  end

end
