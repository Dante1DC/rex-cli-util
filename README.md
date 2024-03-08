# Rex
Rex is a file explorer utility for the command line, developed in Ruby. 

## Installation
Step 1: Add this repo to path. 
### Windows
1. Search "edit the system environment variables" in the search bar on the bottom of your screen
2. Click "Environment Variables..."
3. Click "Path" in the "User variables for username" box
4. Click "Edit"
5. Click "New"
6. Type the absolute path to the folder of the repo. For example, "C:\Users\username\Documents\the-coolest-repo"
7. Click "OK." Then, "OK." Finally, click "OK."
8. Edit init.rb with the file path to "rex.rb." 
9. Run init.rb 

## Usage 
You can quickly navigate the command line by typing the name of your target folder/file. Once there's only one possible navigation option, Rex automatically navigates through that folder. If you typed in the name of a Ruby file, Rex automatically opens your favorite code editor! You can also type commands, such as ";e", to type command line arguments exactly how you're used to.

## Notes
Rex only works on Windows 11 currently. Mac and Linux implementations are on the way.
Additionally, there are a couple missing features that will make their way into the project soon:
- Application integration for other program files.
    - I work a lot in Ruby--and this tool was written in Ruby--so I figured opening Ruby files first was the most useful for me. I plan on adding C, JS, TS, Python, MD, and a bunch of other file types to the list. Additionally, I'd like most files to just open in their default Windows application, so I'll be working on that soon.
-  Better UI
    - The UI is a bit clunky right now.

If you have any feedback or feature ideas, send them my way!     