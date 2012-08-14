module Bop
  class BopError < StandardError; end
  class RootPageNotFound < BopError; end
  class PageNotFound < BopError; end
  class TemplateNotFound < BopError; end
  class MarkupNotFound < BopError; end
end