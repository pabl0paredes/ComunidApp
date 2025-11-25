class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]
  before_action :skip_authorization, only: [ :home ]
  # before_action :verify_policy_scoped, only: [:home]

  def home
  end

  def no_community
  end
end
