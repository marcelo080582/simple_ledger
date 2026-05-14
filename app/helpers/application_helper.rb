module ApplicationHelper
  def format_money(cents)
    number_to_currency(
      cents.to_f / 100,
      unit: "R$",
      separator: ",",
      delimiter: "."
    )
  end
end
