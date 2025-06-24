module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :doorkeeper_authorize!, only: [ :create, :login ]

      def create
        user = User.new(user_params)
        client_app = Doorkeeper::Application.find_by(uid: params[:client_id])
        return render(json: { error: "Invalid client ID" }, status: 403) unless client_app
        if user.save
          access_token = Doorkeeper::AccessToken.create(
            resource_owner_id: user.id,
            application_id: client_app.id,
            expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
            scopes: ""
          )
          render json: {
            message: "User registered successfully",
            access_token: access_token.token,
            token_type: "Bearer",
            expires_in: access_token.expires_in,
            user: {
              id: user.id,
              email: user.email,
              role: user.role,
              created_at: user.created_at,
              updated_at: user.updated_at
            }
          }
        else
          render(json: { error: user.errors.full_messages }, status: 422)
        end
      end

      def login
        user = User.find_for_authentication(email: params[:email])
        if user&.valid_password?(params[:password])
          client_app = Doorkeeper::Application.find_by(uid: params[:client_id])
          return render(json: { error: "Invalid client ID" }, status: 403) unless client_app

          access_token = Doorkeeper::AccessToken.create(
            resource_owner_id: user.id,
            application_id: client_app.id,
            expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
            scopes: ""
          )

          render json: {
            message: "Login successful",
            access_token: access_token.token,
            token_type: "Bearer",
            expires_in: access_token.expires_in,
            user: {
              id: user.id,
              email: user.email,
              role: user.role,
              password: user.encrypted_password,
              updated_at: user.updated_at
            }
          }
        else
          render json: { error: "Invalid email or password" }, status: 401
        end
      end


      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation, :role)
      end
    end
  end
end
