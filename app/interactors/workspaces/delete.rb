# app/interactors/workspaces/delete.rb
module Workspaces
    class Delete
      include Interactor
  
      def call
        workspace = context.user.workspaces.find(context.id)
        workspace.destroy
      end
    end
  end
  