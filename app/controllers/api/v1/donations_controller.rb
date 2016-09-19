module Api
  module V1
    class DonationsController < ApplicationController
      def create
        return render_errors(['User must be a donator']) unless donator?
        donation = Donation.create(create_params.merge(donator: current_user))
        return render_errors(donation.errors.full_messages) unless donation.valid?
        head :created
      end

      def activate
        return render_errors(['User must be a volunteer']) unless current_user.volunteer?
        donation = Donation.find(params[:id])
        return render_errors(['Inexistent Fridge']) unless valid_fridge?
        donation.update(activate_params.merge(volunteer: current_user, status: :active))
        render json: donation, status: :ok
      end

      def finish
        return render_errors(['User must be a fridge']) unless current_user.fridge?
        donation = Donation.find(params[:id])
        donation.update(fridge: current_user, status: :finished)
        render json: donation, status: :ok
      end

      def index
        return render json: { error: 'Not a valid status' } unless valid_status?
        render json: donations, status: :ok
      end

      private

      def valid_status?
        Donation.statuses.include? index_params[:status]
      end

      def donations
        donations = Donation.where(status: Donation.statuses[index_params[:status]])
        return donations.where(donator: current_user).page(params[:page]) if donator?
        donations.page(params[:page])
      end

      def donator?
        current_user.donator?
      end

      def index_params
        params.require(:status)
        params.permit(:status)
      end

      def create_params
        params.permit(:pickup_time_from, :pickup_time_to, :description)
      end

      def activate_params
        params.permit(:fridge_id)
      end

      def valid_fridge?
        params[:fridge_id].blank? || Fridge.find_by_id(params[:fridge_id]).present?
      end
    end
  end
end
