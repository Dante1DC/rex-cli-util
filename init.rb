# EDIT: Path to the Ruby script. The below path, by default, is an example.
ruby_script_path = "C:\\Users\\username\\Documents\\the-coolest-repo\\rex.rb"

bat_path = "rex.bat"
content = <<-BAT
@echo off
ruby #{ruby_script_path} %*
BAT

File.open(bat_path, "w") do |file|
  file.puts content
end

puts "Batch file created successfully at #{bat_path}"
