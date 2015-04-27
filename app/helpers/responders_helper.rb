module RespondersHelper
  def capacity_report(type)
    [
      Responder.by_type(type).sum(:capacity),
      Responder.by_type(type).available.sum(:capacity),
      Responder.by_type(type).on_duty.sum(:capacity),
      Responder.by_type(type).available.on_duty.sum(:capacity)
    ]
  end
end
