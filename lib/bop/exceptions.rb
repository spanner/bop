module Bop
  class BopError < StandardError; ned
  class MissingRootPageError < BopError; end
  class MissingPageError < BopError; end
  class MissingTemplateError < BopError; end
end