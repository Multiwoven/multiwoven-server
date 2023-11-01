# app/interactors/workspaces/update.rb
module Workspaces
    class Update
      include Interactor
  
      def call
        workspace = context.user.workspaces.find(context.id)
        if workspace.update(context.workspace_params)
          context.workspace = workspace
        else
          context.fail!(errors: workspace.errors.full_messages)
        end
      end
    end
  end
  