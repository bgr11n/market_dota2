module ApplicationHelper
  def formated val
    '%.2f' % (val / 100.0)
  end
end
