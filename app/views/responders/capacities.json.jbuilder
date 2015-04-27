json.capacity do
  Responder::TYPES.each do |type|
    json.set! type, Responder.by_type(type).capacity_report
  end
end