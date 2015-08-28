module ApplicationHelper
  def formated val
    Settings[:app][:currency][:sign] + '%.2f' % (val / 100.0) + ' ' + Settings[:app][:currency][:code]
  end
end
