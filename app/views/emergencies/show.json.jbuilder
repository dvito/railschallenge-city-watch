json.set! :full_responses, Emergency.full_responses
json.emergency do
  json.extract! @emergency, :code, :fire_severity, :police_severity, 
  :medical_severity, :resolved_at
  json.set! :responders, @emergency.responders.pluck(:name)
end