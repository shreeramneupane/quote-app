# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'csv'
quotes_data = CSV.read("quotes.csv")
quotes_data.shift
parser = QuoteParser.new

quotes_data.each do |q|
  raw = q[0]
  puts raw
  parsed = parser.parse(raw: raw)

  Quote.create_with(author: parsed.author).find_or_create_by!(title: parsed.title)
end
