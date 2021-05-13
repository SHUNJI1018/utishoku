class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :diys, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :diy_comments, dependent: :destroy
  
  # フォロー・フォロワー機能
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower
  has_many :followings, through: :relationships, source: :followed

  # ログイン時の空白を許可しない
  validates :nickname, :last_name, :first_name, :last_kana_name, :first_kana_name, presence: true

  # サインイン時のカタカナ入力に関するバリデーション
  validates :last_kana_name, :first_kana_name,
            format: { with: /\A[\p{katakana}　ー－&&[^ -~｡-ﾟ]]+\z/, message: "全角カタカナのみで入力して下さい" }

  # ユーザーステータスの二択
  enum is_valid: { 有効: false, 退会: true }
  
  def follow(customer_id)
    relationships.create(followed_id: customer_id)
  end

  def unfollow(customer_id)
    relationships.find_by(followed_id: customer_id).destroy
  end

  def following?(customer)
    followings.include?(customer)
  end

end
