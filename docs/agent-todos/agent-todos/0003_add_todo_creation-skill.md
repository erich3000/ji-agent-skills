---
title: Add Skill `/todo-creation`
status: doing
---

- use the /skill-development skill to perfrom this task
- We want to create a new skill called /skill-creation
- This skill asks the user for a category and a title
- The skill then creates a new to-do Markdown file
- This new file is created in a directory that bears the name of the category
- If this directory does not yet exist, it is created
- The file has a sequential number (four digits) followed by the title in snake case.
- When calculating the numerical prefix, the skill should note that files with the status “done” are also taken into account.
- If the title is longer than 60 characters, the file name is truncated.
- A front matter section is created at the beginning of the to-do file.
- This contains two fields: title and status. The status is initially new.
- After this header, the title is repeated as an H1 heading.
- Below this is a prompt for the user to enter or copy in a description.
- The user should then set the status to ready.
- Add a template for a new to-do to the skill's resource directory.
- can this be improved by implemting a bash script?
