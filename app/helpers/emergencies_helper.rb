module EmergenciesHelper
  def full_responses
    [
      Emergency.full_responses.count,
      Emergency.count
    ]
  end
end
