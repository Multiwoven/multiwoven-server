# app/interactors/workspaces/update.rb

module Workspaces
  class Update
    include Interactor

    def call
      workspace = Workspace.find_by(id: context.id)
      if workspace && workspace.update(context.workspace_params)
        context.workspace = workspace
      else
        context.fail!(errors: workspace&.errors&.full_messages || ["Couldn't find Workspace"])
      end
    end
  end
end
