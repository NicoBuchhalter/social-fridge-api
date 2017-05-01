class Notification < ActiveRecord::Base
  belongs_to :from, class_name: 'User'
  belongs_to :to, class_name: 'User'

  enum n_type: [:donation_activated, :donation_expired, :activation_time_passed,
                :donation_deactivated, :donation_nearby]

  validates :to, presence: true
end
