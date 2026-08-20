class Public::ApplicationController < ApplicationController
  include Public::Authentication
  layout "public"
end
