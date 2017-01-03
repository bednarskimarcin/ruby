require 'creek'

=begin
creek = Creek::Book.new "specs/fixtures/sample.xlsx"
sheet= creek.sheets[0]

sheet.rows.each do |row|
  puts row # => {"A1"=>"Content 1", "B1"=>nil, C1"=>nil, "D1"=>"Content 3"}
end

sheet.rows_with_meta_data.each do |row|
  puts row # => {"collapsed"=>"false", "customFormat"=>"false", "customHeight"=>"true", "hidden"=>"false", "ht"=>"12.1", "outlineLevel"=>"0", "r"=>"1", "cells"=>{"A1"=>"Content 1", "B1"=>nil, C1"=>nil, "D1"=>"Content 3"}}
end

sheet.state   # => 'visible'
sheet.name    # => 'Sheet1'
sheet.rid     # => 'rId2'
=end

contract_numbers_file_path = ARGV[0]

if contract_numbers_file_path == nil
	abort("Usage: script.rb contract_numbers_file_path")
end

puts "COPY eques_back_payments (id, contractnumber, equescontractnumber, backpayment_amount, backpayment_date) FROM stdin;"

creek = Creek::Book.new contract_numbers_file_path
sheet = creek.sheets[0]

counter = 1;
sheet.rows.each do |row|
  #Skip Header
  if counter == 1
	counter += 1
	next
  end
  
  sql = counter.to_s + "\t"
  row.each_with_index do |(key, value), index|
	if value != nil
		if key[/^C/] 
			sql += ('%.2f' % value).gsub(/[\s,\.]/, "") 
		else
			sql += value.to_s 
		end
	end
	
	if index < 3
		sql += "\t"
	end
  end
  
  puts sql
  counter += 1
end

puts "\\."
