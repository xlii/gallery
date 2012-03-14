class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :database_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation

  def self.find_for_open_id(access_token, signed_in_resource=nil)
		data = access_token.info		
		if user = User.where(:email => data["email"]).first		
      user.update_attributes :name => "#{data["first_name"]} #{data["last_name"]}" if user.name != "#{data["first_name"]} #{data["last_name"]}"
		  user
		else
		  User.create!(:email => data["email"], :password => Devise.friendly_token[0,20], :name => "#{data["first_name"]} #{data["last_name"]}")
		end
	end
	
	def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["user_hash"]
        user.email = data["email"]
        user.name = "#{data["first_name"]} #{data["last_name"]}"
      end
    end
  end
end
