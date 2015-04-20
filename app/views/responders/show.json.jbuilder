json.responder do
  json.extract! @responder, :emergency_code, :name, :type, :capacity, :on_duty
end