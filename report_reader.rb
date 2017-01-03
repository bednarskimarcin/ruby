require('csv.rb')

contract_numbers_file_path = ARGV[0]
dir = ARGV[1]
output_path = ARGV[2]

if dir == nil or output_path == nil or contract_numbers_file_path == nil
	abort("Usage: report_reader.rb contract_numbers_file_path input_dir_name output_file_path")
end

contract_numbers = []
CSV.foreach(contract_numbers_file_path) do |row|
  if /contractnumber/.match(row[0])
	next
  end
  
  length = row[0].length
  if (length <= 10)
	contract_numbers.push(row[0])
  end
end


pattern = "'" + contract_numbers.join("\\|")  + "'"
puts pattern

Dir.chdir(dir)
#rbfiles = File.join("**", '*analityka_podatkowy_wedlug_udzielenia*.csv')
rbfiles = File.join("**", '6000007*.txt')
Dir.glob(rbfiles).each  do |x| 
	command = "echo Grepping #{x}" + " >> " + output_path
	puts command
	system(command)
	
	command = "cat " + dir + "/" + x + " |grep " + pattern + " >> " + output_path
	system(command)
	puts "done"
end

