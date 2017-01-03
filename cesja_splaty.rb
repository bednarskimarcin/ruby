require('csv.rb')

contract_numbers_file_path = ARGV[0]

if contract_numbers_file_path == nil 
	abort("Usage: cesja_splat.rb contract_numbers_file_path ")
end

CSV.foreach(contract_numbers_file_path, {:col_sep => ";"}) do |row|
  #--1503001538	2016-01-07	219,00
  #insert into tmp_solko_cesja_zwrotna_splaty values('1503001538','2016-01-07','219,00');
  puts  "--" + row[0] + " " + row[1] + " " + row[2]
  puts  "insert into tmp_solko_cesja_zwrotna_splaty values('" + row[0] + "', '" + row[1] + "', '" + row[2] + "');"
  puts ""
end


