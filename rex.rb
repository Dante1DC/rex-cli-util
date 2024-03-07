#!/usr/bin/env ruby
require 'io/console'
require 'fileutils'

def list_directory(path, selected)
  system("clear") || system("cls")
  puts "Contents of #{path}:"
  Dir.children(path).each_with_index do |item, index|
    prefix = index == selected ? '-> ' : '   '
    item_display = File.directory?(File.join(path, item)) ? "[DIR] #{item}" : "[FILE] #{item}"
    puts "#{prefix}#{item_display}"
  end
end

def enter(current_path, item)
  selected_path = File.join(current_path, item)

  if File.directory?(selected_path)
    return explore_directory(selected_path)
  elsif File.extname(selected_path) == '.rb'
    system("code #{selected_path}")
  else
    system("clear") || system("cls")
    puts "Opening #{item}:"
    puts File.read(selected_path) rescue 'Unable to read file'
    puts "\nPress any key to return..."
    STDIN.getch
  end

  nil
end

def execute_custom_command(current_path)
  system("clear") || system("cls")
  puts "Enter command to execute:"
  command = STDIN.gets.chomp
  system("cd #{current_path} && #{command}")
  puts "\nCommand executed. Press any key to return..."
  STDIN.getch
end

def explore_directory(current_path)
  selected = 0
  items = Dir.children(current_path)
  filter = ""
  update_display = -> {
    system("clear") || system("cls")
    filtered_items = items.select { |item| item.downcase.start_with?(filter.downcase) }
    if filtered_items.size == 1 && filter != ';e'
      enter_result = enter(current_path, filtered_items.first)
      unless enter_result.nil?
        return enter_result
      end
    end
    list_directory(current_path, selected)
    puts "\nType to filter, ';b' to go back, ';q' to quit, ';e' to execute command."
    puts "Filter: #{filter}" unless filter.empty?
  }

  loop do
    should_break = update_display.call
    break if should_break

    input = STDIN.getch  # Collect user input

    case input
    when "\u0003"
      puts "Exiting..."
      exit 0
    when "\r"  # Enter key
      if filter == ';b'
        return
      elsif filter == ';q'
        exit 0
      elsif filter == ';e'
        execute_custom_command(current_path)
        filter = ''  # Clear filter after executing command
      end
      filter = '' unless filter == ';e'
    when "\u007F"  # Backspace
      filter.chop!
    else
      filter << input
    end
  end
end

def print_intro_from_file(file_path)
  if File.exist?(file_path)
    intro_text = File.read(file_path)
    red_text = "\e[31m#{intro_text}\e[0m"
    loop do
      system("clear") || system("cls")
      puts red_text
      puts "\n\e[0mWelcome to the \e[31mRex\e[0m Command-Line File Explorer UI! Type ';' commands to navigate or execute. \nPress 'Enter' when you are ready to proceed.\e[0m"
      user_input = STDIN.getch
      break if user_input == "\r"  # Enter key
    end
  else
    puts "\e[31mWelcome message file not found.\e[0m"
  end
end

intro_file_path = 'rex.txt'
print_intro_from_file(intro_file_path)
script_directory = File.dirname(__FILE__)
parent_directory = File.expand_path('..', script_directory)
parent_directory = File.expand_path('..', parent_directory)
explore_directory(parent_directory)
