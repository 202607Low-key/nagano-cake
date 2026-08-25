class Public::HomesController < Public::ApplicationController
  allow_unauthenticated_access only: %i[ top about ]
  def top
    @new_items = Item.where(is_active: true).order(created_at: :desc).limit(4)
  end

  def about
  end
end
