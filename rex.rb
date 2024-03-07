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

# Can open VS Code iff the file is Ruby & VS Code is on PATH
def handle_navigation(current_path, selected)
  items = Dir.children(current_path)
  selected_item = items[selected]
  selected_path = File.join(current_path, selected_item)

  if File.directory?(selected_path)
    explore_directory(selected_path)
  else
    if File.extname(selected_path) == '.rb'
      system("code #{File.dirname(selected_path)}")
    else
      system("clear") || system("cls")
      puts "Opening #{selected_item}:"
      puts File.read(selected_path)
      puts "\nPress any key to return..."
      STDIN.getch
    end
  end
end

def execute_command(current_path)
  system("clear") || system("cls")
  puts "Enter command to execute (or type 'exit' to return):"
  command = gets.chomp
  return if command == 'exit'

  system("cd #{current_path} && #{command}")
  puts "\nCommand executed. Press any key to return..."
  STDIN.getch
end

def explore_directory(current_path)
  selected = 0
  items = Dir.children(current_path)
  filter = ""
  navigation_enabled = true  # Start with navigation disabled

  update_display = -> {
    system("clear") || system("cls")
    filtered_items = items.select { |item| item.downcase.start_with?(filter.downcase) }
    filtered_items.each_with_index do |item, index|
      prefix = selected == index ? '-> ' : '   '
      item_display = File.directory?(File.join(current_path, item)) ? "[DIR] #{item}" : "[FILE] #{item}"
      puts "#{prefix}#{item_display}"
    end
    puts "\nUse 'Z' to toggle navigation mode. Type to filter, 'Q' to quit."
    puts "Filter: #{filter}" unless filter.empty?
  }

  loop do
    update_display.call

    input = STDIN.getch.downcase

    case input
    when "\u0003"
      puts "Exiting..."
      exit 0
    when 'z'
      navigation_enabled = !navigation_enabled
      filter = '' unless navigation_enabled
      next
    when "\u007F"
      filter.chop! unless navigation_enabled
    when 'q'
      break unless navigation_enabled
    else
      if navigation_enabled
        case input
        when "w"
          selected = [0, selected - 1].max
        when "s"
          selected = [selected + 1, items.length - 1].min
        when "d"
          handle_navigation(current_path, selected)
          items = Dir.children(current_path)
          selected = 0
        when "a"
          return
        end
      else
        filter << input unless input < 'a' || input > 'z'
        filtered_items = items.select { |item| item.downcase.start_with?(filter.downcase) }
        selected = 0
        selected = [0, filtered_items.length - 1].min if filtered_items.any?
      end
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
      puts "\n\e[0mWelcome to the \e[31mRex\e[0m Command-Line File Explorer UI! Use 'WASD' to navigate, 'E' to execute commands. \nPress 'D' when you are ready to proceed.\e[0m"
      user_input = STDIN.getch.upcase
      break if user_input == 'D'
    end
  else
    puts "\e[31mWelcome message file not found.\e[0m"
  end
end

intro_file_path = 'rex.txt'
print_intro_from_file(intro_file_path)
script_directory = File.dirname(__FILE__)  # Get the directory where the script is located
parent_directory = File.expand_path('..', script_directory)  # Move up one level
parent_directory = File.expand_path('..', parent_directory)  # Move up one level
explore_directory(parent_directory)  # Start from the parent directory
