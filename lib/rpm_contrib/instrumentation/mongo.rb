if defined?(::Mongo) && !NewRelic::Control.instance['disable_mongodb']
  module Mongo #:nodoc:
    class Collection
      class << self
        alias :old_included :included

        def included(model)
          old_included(model)
          super
        end
      end
    end
  end

  module RPMContrib::Instrumentation
    module Mongo
      module Collection
        def included(model)
          model.class_eval do
            [
              :find, :find_one, :save, :insert, :remove, :update, :create_index, :drop_index, :drop,
              :find_and_modify, :map_reduce, :group, :distinct, :rename, :index_information, :options, :stats, :count
            ].each do |method|
              add_method_tracer method, "Database/#{self.class.name}/#{method}"
            end
          end
          super
        end
      end
    end
    ::Mongo::Collection.extend(RPMContrib::Instrumentation::Mongo::Collection)
  end
end
