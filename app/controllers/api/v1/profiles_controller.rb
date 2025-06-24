module Api
  module V1
    class ProfilesController < ApplicationController
      private

      def profile_params
        params.require(:profile).permit(:name, :email, :bio, :avatar)
      end
    end
  end
end
