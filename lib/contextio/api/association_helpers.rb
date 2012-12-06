class ContextIO
  class API
    module AssociationHelpers
      def self.class_for_association_name(association_name)
        @associations[association_name]
      end

      def self.register_resource(klass, association_name)
        @associations ||= {}
        @associations[association_name] = klass
      end
    end
  end
end
