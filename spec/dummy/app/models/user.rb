class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
  include Rhinoart::User::Notificable
  include Rhinoart::User::Approvable
  include Rhinoart::User::Rolifable
  include Rhinoart::User::Localable

  #store :info, accessors: Rhinoart.additional_user_attributes, coder: JSON
  #mount_uploader :avatar, Rhinoart::ImageUploader
  #has_paper_trail Rhinoart.paper_trail if Rhinoart.paper_trail


  rolify
end
