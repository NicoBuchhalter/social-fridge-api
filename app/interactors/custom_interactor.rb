class CustomInteractor
  include Interactor

  FORBIDDEN_MSG = 'User not allowed to poll.'.freeze
  BAD_REQUEST_MSG = 'The specified carbooking is not available for cancel for this user.'.freeze
  NOT_FOUND_MSG = 'The specified carboking does not exist.'.freeze
  NOT_EXIST_MSG = 'The specified car/location does not exist.'.freeze
  NOT_VALID_MSG = 'The specified date is not valid.'.freeze
  YOU_HAVE_BOOKING_MSG = 'You already have a booking in that date.'.freeze
  CAR_HAS_BOOKING_MSG = 'The specified car is not available for booking in that date.'.freeze
  NONCE_REQUIRED_MSG = 'Payment method nonce required.'.freeze
  BRAINTREE_POLICY_MSG = 'Braintree policy has failed'.freeze
  ALREADY_CANCELLED_MSG = 'Vanpool already cancelled.'.freeze
  VANPOOLER_NOT_FOUND = 'User not present in vanpool.'.freeze
  MVR_NOT_APPROVED = 'MVR has not been approved.'.freeze
  VANPOOL_INSTANCE_NOT_EXIST = 'Vanpool instance not found.'.freeze

  def fail_with_hash(status, error)
    context.error = { status: status, json: { errors: error } }
    context.fail!
  end

  def bad_request(message)
    fail_with_hash(:bad_request, message)
  end

  def not_found(message)
    fail_with_hash(:not_found, message)
  end

  def forbidden(message)
    fail_with_hash(:forbidden, message)
  end

  def unauthorized(message)
    fail_with_hash(:unauthorized, message)
  end

  def precondition_failed(message)
    fail_with_hash(:precondition_failed, message)
  end
end
