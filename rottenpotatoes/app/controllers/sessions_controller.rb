class SessionsController < ApplicationController
    def create
        session[:username] = env["omniauth.auth"].info.name

        #user = User.from_omniauth(env["omniauth.auth"])
        #session[:user_id] = user.id
        redirect_to root_url
      end
    
      def destroy
        session[:username] = nil
        redirect_to root_url
    end
end
