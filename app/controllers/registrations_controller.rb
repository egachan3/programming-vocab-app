class RegistrationsController < Devise::RegistrationsController
  before_action :redirect_guest_user, only: [ :edit, :update, :destroy ]
end
