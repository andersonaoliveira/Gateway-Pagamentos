class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validate :email_domain

  def email_domain
    domain = email.split('@').last
    return unless email.present? && (domain != 'locaweb.com.br')

    errors.add(:email, 'Sistema exclusivo para administradores locaweb')
  end
end
