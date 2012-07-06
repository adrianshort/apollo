class ErrorLog
  include MongoMapper::Document

  key :ts, Time
  key :params, Hash
  key :pois_returned, Integer

end
