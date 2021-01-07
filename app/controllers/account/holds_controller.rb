module Account
  class HoldsController < BaseController
    def create
      @item = Item.find(params[:item_id])
      @new_hold = Hold.new(item: @item, member: current_member, creator: current_user)

      @new_hold.transaction do
        if @new_hold.save
          @new_hold.start! if @new_hold.ready_for_pickup?
          redirect_to item_path(@item), success: "Hold placed."
        else
          redirect_to item_path(@item), error: "Something went wrong!"
        end
      end
    end

    def destroy
      current_member.holds.find(params[:id]).destroy!
      redirect_to account_home_path
    end
  end
end
