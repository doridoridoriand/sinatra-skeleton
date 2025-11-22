module MyApp
  class Error < StandardError; end

  class ValidationError < Error; end
  class NotFoundError < Error; end
  class UnauthorizedError < Error; end
  class ForbiddenError < Error; end
end
