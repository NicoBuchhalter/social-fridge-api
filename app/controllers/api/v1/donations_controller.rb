module Api
  module V1
    class DonationsController < ApplicationController

      def create
        return render json: {errors: ['User must be a donator']} unless current_user.donator?
        donation = Donation.create(create_params.merge(donator: curren))
        unless donation.valid?
          return render json: { errors: donation.errors.full_messages }, status: :bad_request
        end
        head :created
      end

      def index
        Donator.joins(:donations).by_distance(origin: current_location)).page(params[:page])
      end

      private

      def create_params
        params.permit(:pickup_time_from, :pickup_time_to, :description)
      end
    end
  end
end
