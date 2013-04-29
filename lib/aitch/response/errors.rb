module Aitch
  class Response
    ERRORS = {
      400 => BadRequestError,
      401 => UnauthorizedError,
      402 => PaymentRequiredError,
      403 => ForbiddenError,
      404 => NotFoundError,
      405 => MethodNotAllowedError,
      406 => NotAcceptableError,
      407 => ProxyAuthenticationRequiredError,
      408 => RequestTimeOutError,
      409 => ConflictError,
      410 => GoneError,
      411 => LengthRequiredError,
      412 => PreconditionFailedError,
      413 => RequestEntityTooLargeError,
      414 => RequestURITooLongError,
      415 => UnsupportedMediaTypeError,
      416 => RequestedRangeNotSatisfiableError,
      417 => ExpectationFailedError,
      422 => UnprocessableEntityError,
      423 => LockedError,
      424 => FailedDependencyError,
      426 => UpgradeRequiredError,
      428 => PreconditionRequiredError,
      429 => TooManyRequestsError,
      431 => RequestHeaderFieldsTooLargeError,
      500 => InternalServerErrorError,
      501 => NotImplementedError,
      502 => BadGatewayError,
      503 => ServiceUnavailableError,
      504 => GatewayTimeOutError,
      505 => VersionNotSupportedError,
      507 => InsufficientStorageError,
      511 => NetworkAuthenticationRequiredError
    }
  end
end
