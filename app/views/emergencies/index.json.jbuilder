json.set! :full_responses, Emergency.full_responses
json.emergencies @emergencies do |emergency|
  json.extract! emergency, :code, :fire_severity, :police_severity, :medical_severity, :resolved_at
  json.url emergency_url(emergency, format: :json)
end
