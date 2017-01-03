require('csv.rb')

=begin
Czyta plik CSV z wpłatami z eques. 

Przykład:
sms_contractnumber	navilex_contractnumber	 backpayment_amount 	backpayment_date
1204005298	8158871	-300,00      	2015-12-15
1204005298	8158871	-284,63      	2015-12-15

Na wyjściu na konsolę wypisuje dump COPY na stdin, który można wgrać do pliku i wczytać do bazy

COPY eques_back_payments (id, contractnumber, equescontractnumber, backpayment_date, backpayment_amount) FROM stdin;
1       1204005298      8158871 2015-12-15      -30000
2       1204005298      8158871 2015-12-15      -28463
...
49579	1409010948	12080489	2015-07-27	17000
\.
=end

contract_numbers_file_path = ARGV[0]

if contract_numbers_file_path == nil
	abort("Usage: script.rb contract_numbers_file_path")
end

puts "SET statement_timeout = 0;"
puts "SET lock_timeout = 0;"
puts "SET client_encoding = 'UTF8';"
puts "SET standard_conforming_strings = on;"
puts "SET check_function_bodies = false;"
puts "SET client_min_messages = warning;"
puts "SET search_path = public, pg_catalog;"

puts "COPY eques_back_payments (id, contractnumber, equescontractnumber, backpayment_date, backpayment_amount) FROM stdin;"

counter = 1;
CSV.foreach(contract_numbers_file_path, { :col_sep => ';', :converters => :all}) do |row|
  puts counter.to_s + "\t" + row[0].to_s + "\t" + row[1].to_s + "\t" + row[3].to_s + "\t" + row[2].gsub(/[\s,]/, "")
  counter += 1
end

puts "\\."



