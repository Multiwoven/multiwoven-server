# frozen_string_literal: true

# app/interactors/authentication/login.rb
module Authentication
  class Login
    include Interactor

    def call
      begin
        user = User.find_by(email: context.params[:email])
      rescue => e
        Rails.logger.error("Login Interactor Exception: #{e.message}")
        context.fail!(error: "An error occurred while finding the user.")
        return
      end

      # Check if the email is valid and password is correct
      if user&.valid_password?(context.params[:password])
        # Check if the user is verified
        if user.verified?
          token, payload = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
          user.update!(jti: payload["jti"])

          context.token = token
        else
          context.fail!(error: "Account not verified. Please verify your account.")
        end
      else
        context.fail!(error: "Invalid email or password")
      end
    end
  end
end

