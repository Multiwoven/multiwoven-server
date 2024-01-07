# frozen_string_literal: true

# spec/interactors/authentication/signup_spec.rb

require "rails_helper"

RSpec.describe Authentication::Signup, type: :interactor do
  subject(:context) { described_class.call(params:) }

  describe ".call" do
    context "when provided with valid user attributes" do
      let(:params) do
        {
          name: "Test User",
          email: "user@example.com",
          password: "password",
          password_confirmation: "password",
          company_name: "Test Company"
        }
      end

      it "succeeds" do
        expect(context).to be_success
      end

      it "provides a success message" do
        expect(context.message).to eq("Signup successful!")
      end

      it "creates a new user" do
        expect { context }.to change(User, :count).by(1)
      end

      it "creates a new organization" do
        expect { context }.to change(Organization, :count).by(1)
      end

      it "creates a new workspace" do
        expect { context }.to change(Workspace, :count).by(1)
      end
    end

    context "when company_name is not present" do
      let(:params) do
        {
          name: "Test User",
          email: "user@example.com",
          password: "password",
          password_confirmation: "password"
          # company_name is omitted
        }
      end

      it "fails" do
        expect(context).to be_failure
      end

      it "does not create a new user" do
        expect { context }.not_to change(User, :count)
      end

      it "does not create a new organization" do
        expect { context }.not_to change(Organization, :count)
      end

      it "does not create a new workspace" do
        expect { context }.not_to change(Workspace, :count)
      end

      it "provides error messages related to missing company_name" do
        expect(context.errors).to include("Company name can't be blank")
      end
    end

    context "when provided with invalid user attributes" do
      context "password and password_confirmation do not match" do
        let(:params) do
          {
            name: "User",
            email: "user@example.com",
            password: "password",
            password_confirmation: "wrong_password"
          }
        end

        it "fails" do
          expect(context).to be_failure
        end

        it "provides error messages" do
          expect(context.errors).to include("Password confirmation doesn't match Password")
        end
      end

      context "email is missing" do
        let(:params) do
          {
            name: "Test User",
            email: "",
            password: "password",
            password_confirmation: "password"
          }
        end

        it "fails" do
          expect(context).to be_failure
        end

        it "provides error messages" do
          expect(context.errors).to include("Email can't be blank")
        end
      end

      context "name is missing" do
        let(:params) do
          {
            name: "",
            email: "user@example.com",
            password: "password",
            password_confirmation: "password"
          }
        end

        it "fails" do
          expect(context).to be_failure
        end

        it "provides error messages" do
          expect(context.errors).to include("Name can't be blank")
        end
      end

      context "when provided with an existing company name" do
        let!(:existing_organization) { create(:organization, name: "Existing Company") }
        let(:params) do
          {
            name: "Test User",
            email: "user@example.com",
            password: "password",
            password_confirmation: "password",
            company_name: "Existing Company"
          }
        end

        it "fails" do
          expect(context).to be_failure
        end

        it "does not create a new user" do
          expect { context }.not_to change(User, :count)
        end

        it "provides error messages related to company name" do
          expect(context.errors).to include("Company name has already been taken")
        end
      end
    end
  end
end
