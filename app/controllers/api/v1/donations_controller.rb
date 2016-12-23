module Api
  module V1
    class DonationsController < ApplicationController
      def create
        return render_errors(['User must be a donator']) unless donator?
        donation = Donation.create(create_params.merge(donator: current_user))
        return render_errors(donation.errors.full_messages) unless donation.valid?
        head :created
      end

      def reopen
        return render_errors(['User must be a donator']) unless donator?
        donation = Donation.find_by_id(params[:id])
        return render_errors(['Inexistent Donation']) unless donation.present? || !donation.active?
        donation.update(status: :open, activated_at: nil)
        head :ok
      end

      def activate
        return render_errors(['User must be a volunteer']) unless volunteer?
        donation = Donation.find(params[:id])
        return render_errors(['Inexistent Fridge']) unless valid_fridge?
        donation = donation.activate(activate_params, current_user)
        render json: donation, status: :ok
      end

      def deactivate
        return render_errors(['User must be a volunteer']) unless volunteer?
        donation = Donation.find(params[:id])
        donation = donation.deactivate(current_user)
        render json: donation, status: :ok
      end

      def ongoing
        return render_errors(['User must be a fridge']) unless donator?
        donation = Donation.find(params[:id])
        donation.update status: :ongoing
        render json: donation, status: :ok
      end

      def finish
        return render_errors(['User must be a fridge']) unless fridge?
        donation = Donation.find(params[:id])
        donation.status = :finished
        donation.fridge = current_user if fridge?
        donation.save
        render json: donation, status: :ok
      end

      def cancel
        return render_errors(['User must be a Donator']) unless donator?
        donation = Donation.find(params[:id])
        return render_errors(['User must own the donation']) if donation.donator != current_user
        donation.update(status: :cancelled)
        head :ok
      end

      def open
        donations = Donation.includes(:donator).available.order(:pickup_time_to)
        donations = donations.where(donator: current_user) if donator?
        render json: donations, status: :ok
      end

      def active
        donations = Donation.includes(:donator).active.order(:updated_at)
        donations = donations.where(donator: current_user) if donator?
        donations = donations.where(volunteer: current_user) if volunteer?
        render json: donations, status: :ok
      end

      def finished
        donations = Donation.includes(:donator).where(status: [:finished, :cancelled])
                            .order(:updated_at)
        donations = donations.where(donator: current_user) if donator?
        donations = donations.where(volunteer: current_user) if volunteer?
        render json: donations, status: :ok
      end

      private

      def create_params
        [:pickup_time_from, :pickup_time_to].each { |p| params.require(p) }
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
