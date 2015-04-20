json.emergency do
  json.extract! @emergency, :code, :fire_severity, :police_severity, 
  :medical_severity, :full_response, :resolved_at
  json.set! :responders, @emergency.responders.pluck(:name)
end