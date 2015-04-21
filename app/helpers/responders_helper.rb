module RespondersHelper

  def capacity_report(type)
    [
      type.sum(:capacity),
      type.available.sum(:capacity),
      type.on_duty.sum(:capacity),
      type.available.on_duty.sum(:capacity),
    ]
  end
end
