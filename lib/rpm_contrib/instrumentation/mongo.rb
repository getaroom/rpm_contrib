if defined?(::Mongo) && !NewRelic::Control.instance['disable_mongodb']
  Mongo::Collection.class_eval do
    [
      :save, :insert, :<<, :remove, :update, :generate_indexes, :drop_index, :drop,
      :find_and_modify, :map_reduce, :group, :distinct, :rename, :index_information, :options, :stats
    ].each do |method|
      add_method_tracer method, ['Database/#{self.name}/', method.to_s].join
    end
  end

  ::Mongo::Cursor.class_eval do
    [
      :count, :refresh, :send_initial_query, :close
    ].each do |method|
      add_method_tracer method, ['Database/#{self.collection.name}/', method.to_s].join
    end
  end
end
