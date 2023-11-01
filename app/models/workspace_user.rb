# app/models/workspace_user.rb

class WorkspaceUser < ApplicationRecord
    belongs_to :user
    belongs_to :workspace
  
    validates :role, inclusion: { in: %w[admin member viewer] } # Define roles or use an enum
  end
  