# app/interactors/workspaces/list_all.rb
module Workspaces
    class ListAll
      include Interactor
  
      def call
        context.workspaces = context.user.workspaces
      end
    end
  end
  