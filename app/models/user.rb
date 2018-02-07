class User < ApplicationRecord
  validates :username, presence: true
  validates :uid, presence: true, uniqueness: { case_sensitive: false }, format: { with: /@[a-z\d\-.]+/ }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :authentication_keys => [:login]

  attr_accessor :login

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(uid) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:uid].nil?
        where(conditions).first
      else
        where(uid: conditions[:uid]).first
      end
    end
  end
end
