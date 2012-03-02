module Concerns
  module Audit
    extend ActiveSupport::Concern
    
    included do
      before_save :set_user
    end

    module InstanceMethods
      def created_by
        versions.first.try :user
      end

      def updated_by
        versions.last.try :user
      end

      def set_user
        @user = @user || @updater || Person.current
        true
      end

      def created_from_result?
        !created_by.nil? && created_by.kind_of?(::Event)
      end
      
      def updated_after_created?
        created_at && updated_at && ((updated_at - created_at) > 1.hour)
      end
    end
  end
end
