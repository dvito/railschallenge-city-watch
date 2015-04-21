json.capacity do
  json.set! "Fire", capacity_report(Fire)
  json.set! "Police", capacity_report(Police)
  json.set! "Medical", capacity_report(Medical)
end