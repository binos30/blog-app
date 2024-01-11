# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    def create
      super
      flash.discard(:notice) # Remove the signed in successfully messsage.
    end

    def destroy
      super
      flash.discard(:notice) # Remove the signed out successfully messsage.
    end
  end
end
