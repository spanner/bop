module Bop
  class BaseController < EngineController
    respond_to :html, :json
  
    def index
      respond_with resource
    end

    def show
      respond_with resource
    end

  protected

    # Instance variables like @page are set automatically by the load_and_authorize_resource call.
    # Here we provide generalized access to those variables.
    #
    def self.resource_class(resource_class_name=controller_name)
      @model_class ||= "Bop::#{resource_class_name.to_s.singularize.camelize}".constantize
    end

    def resource_name
      self.class.resource_class.name.underscore.downcase
    end

    def resource
      instance_variable_get("@#{resource_name.intern}")
    end

    def resource=(something)
      instance_variable_set("@#{resource_name.intern}", something)
    end

    def resources
      instance_variable_get("@#{resource_name.pluralize.intern}")
    end

    def resources=(somethings)
      instance_variable_set("@#{resource_name.pluralize.intern}", somethings)
    end

  end
end