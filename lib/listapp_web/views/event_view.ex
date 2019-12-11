defmodule ListappWeb.EventView do
  use ListappWeb, :view
  use Timex

  def host?(current_user, event) do
   current_user == event.host 
  end

  def format_date(date) do
    Timex.format!(date, "{WDfull}, {Mfull} {D}, {YYYY}")
  end

  def format_calendar_icon_day(date) do
    Timex.format!(date, "{0D}")
  end
  def format_calendar_icon_month(date) do
    Timex.format!(date, "{Mshort}")
  end

end
