class AdministratorsController < ApplicationController
  before_action :set_administrator, only: :destroy

  def new
  end

  def create
  end

  def destroy
  end

  private

  def set_administrator
    @administrator = Administrator.find(params[:id])
  end
end
