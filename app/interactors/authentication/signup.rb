# app/interactors/authentication/signup.rb
module Authentication
    class Signup
      include Interactor
  
      def call
        user = User.new(
          email: context.params[:email],
          password: context.params[:password],
          password_confirmation: context.params[:password_confirmation]
        )
        user.confirmation_code = generate_confirmation_code
  
        if user.save
          context.message = "Signup successful!"
        else
          context.fail!(errors: user.errors.full_messages)
        end
      end
  
      private
  
      def generate_confirmation_code
        rand(100_000..999_999).to_s
      end
    end
  end
  