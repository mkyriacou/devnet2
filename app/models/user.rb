class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :city, :country, :sex, :age_range, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :projects
  has_many :responses, as: :reviewer_id

end
