json.capacity do
  Responder::TYPES.each do |type|
    json.set! type, capacity_report(type)
  end
end