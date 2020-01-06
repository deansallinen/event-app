defmodule ListappWeb.EventView do
  use ListappWeb, :view
  use Timex

  def host?(current_user, event) do
    current_user == event.host 
  end

  def format_date(date) do
    Timex.format!(date, "{WDfull}, {Mfull} {D}, {YYYY}")
  end

  def format_event_date(start_date, end_date) do
    case Timex.equal?(start_date, end_date, :days) do
      true -> 
        format_date(start_date)
      false -> 
        "#{format_date(start_date)} - #{format_date(end_date)}"
    end
  end

  def format_time(datetime) do
    Timex.format!(datetime, "{h24}:{m}")
  end
  def format_event_time(start_date, end_date) do
    "#{format_time(start_date)} - #{format_time(end_date)}"
  end

  def format_calendar_icon_day(date) do
    Timex.format!(date, "{0D}")
  end
  def format_calendar_icon_month(date) do
    Timex.format!(date, "{Mshort}")
  end

  def share_link(conn) do
    # "#{conn.host}:#{conn.port}#{conn.request_path}?ref=#{conn.assigns.current_user.id}"
  end

  def today do
    Timex.today
  end

  defp get_years_options do
    Timex.today.year..Timex.today.year + 4
  end
  defp get_minutes_options do
    Enum.map(0..11, fn x -> 
      x * 5 
      |> Integer.to_string 
      |> String.pad_leading(2, "0") 
    end) 
  end

  def default_datetime_select_options do
    [
      year: [options: get_years_options, default: Timex.today.year], 
      day: [default: Timex.today.day], 
      hour: [default: Timex.now.hour],
      minute: [options: get_minutes_options]
    ]
  end

  def my_datetime_select(form, field, opts \\ default_datetime_select_options) do
    builder = fn b ->
      ~e"""
      Date: <%= b.(:day, [class: "form-select"]) %> / <%= b.(:month, [class: "form-select"]) %> / <%= b.(:year, [class: "form-select"]) %>
      Time: <%= b.(:hour, [class: "form-select"]) %> : <%= b.(:minute, [class: "form-select"]) %>
      """
    end

    datetime_select(form, field, [builder: builder] ++ opts)
  end

end
