class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def passthru
		render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
	end
  
  def google 		
	  @user = User.find_for_open_id(request.env["omniauth.auth"], current_user)
	  if @user.persisted?
	    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
	    sign_in_and_redirect @user, :event => :authentication
	  else
	    session["devise.google_data"] = request.env["omniauth.auth"]
	    redirect_to new_user_session_url
	  end		
  end
end
