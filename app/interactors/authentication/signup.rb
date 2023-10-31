# frozen_string_literal: true

module Authentication
  class Signup
    include Interactor

    def call
      create_new_user
      assign_confirmation_code
      save_user
    end

    private

    attr_accessor :user

    def create_new_user
      self.user = User.new(
        email: context.params[:email],
        password: context.params[:password],
        password_confirmation: context.params[:password_confirmation]
      )
    end

    def assign_confirmation_code
      user.confirmation_code = generate_confirmation_code
    end

    def save_user
      if user.save
        context.message = "Signup successful!"
      else
        context.fail!(errors: user.errors.full_messages)
      end
    end

    def generate_confirmation_code
      rand(100_000..999_999).to_s
    end
  end
end
