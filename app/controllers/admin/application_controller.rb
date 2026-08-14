class Admin::ApplicationController < ApplicationController
  include Admin::Authentication
  layout "admin"
end
