class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         omniauth_providers: [:google_oauth2]

  has_many :learning_records

  def self.from_omniauth(auth)
    find_by(provider: auth.provider, uid: auth.uid) ||
      link_existing_account(auth) ||
      create(provider: auth.provider, uid: auth.uid, email: auth.info.email, password: Devise.friendly_token[0, 20])
  rescue ActiveRecord::RecordNotUnique
    find_by(provider: auth.provider, uid: auth.uid)
  end

  def self.link_existing_account(auth)
    user = find_by(email: auth.info.email)
    user&.tap { |u| u.update!(provider: auth.provider, uid: auth.uid) }
  end
  private_class_method :link_existing_account
end
