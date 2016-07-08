module Api
  module V1
    class DonationsController < ApplicationController
      def create
        unless current_user.donator?
          return render json: { errors: ['User must be a donator'] }, status: :bad_request
        end
        donation = Donation.create(create_params.merge(donator: curren))
        unless donation.valid?
          return render json: { errors: donation.errors.full_messages }, status: :bad_request
        end
        head :created
      end

      def activate
        unless current_user.volunteer?
          return render json: { errors: ['User must be a volunteer'] }, status: :bad_request
        end
        donation = Donation.find(params[:id])
        donation.update(activate_params.merge(volunteer: current_user, status: :active))
        render json: donation, status: :ok
      end

      def finish
        unless current_user.fridge?
          return render json: { errors: ['User must be a fridge'] }, status: :bad_request
        end
        donation = Donation.find(params[:id])
        donation.update(fridge: current_user, status: :finished)
        render json: donation, status: :ok
      end

      private

      def create_params
        params.permit(:pickup_time_from, :pickup_time_to, :description)
      end

      def activate_params
        params.permit(:fridge_id)
      end
    end
  end
end
