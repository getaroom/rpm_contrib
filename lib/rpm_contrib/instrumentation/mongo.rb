if defined?(::Mongo) && !NewRelic::Control.instance['disable_mongodb']
  Mongo::Collection.class_eval do
    [
      :find, :find_one, :save, :insert, :remove, :update, :create_index, :drop_index, :drop,
      :find_and_modify, :map_reduce, :group, :distinct, :rename, :index_information, :options, :stats, :count
    ].each do |method|
      add_method_tracer method, ['Database/#{self.class.name}/', method.to_s].join
    end
  end

  ::Mongo::Cursor.class_eval do
    [
      :next_document, :count, :refresh, :to_a
    ].each do |method|
      add_method_tracer method, ['Database/#{self.class.name}', method.to_s].join
    end
  end
end
