class DesignersController < ApplicationController
  def all
    @users = User.all

  end
end
