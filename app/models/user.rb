# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :trackable

  belongs_to :role
  has_many :posts, dependent: :destroy
  has_many :feedbacks, through: :posts

  validates :email, length: { maximum: 255 }
  validates :password,
            presence: true,
            length: {
              in: 8..20
            },
            on: :update,
            if: proc { |user| user.encrypted_password_changed? }

  with_options presence: true,
               length: {
                 minimum: 2,
                 maximum: 100
               },
               format: /\A([^\d\W]|-|\s)*\z/ do
    validates :first_name
    validates :last_name
  end

  before_validation :set_role, on: :create, if: -> { role_id.blank? }
  before_create :set_defaults

  private

  def set_role
    self.role = Role.find_or_create_by!(name: "Member")
  end

  def set_defaults
    self.reset_password_token = SecureRandom.urlsafe_base64
  end
end
