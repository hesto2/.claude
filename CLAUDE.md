As you implement solutions, keep your implementations as simple as you can make them. Write code that a staff engineer would be impressed with due to its ease of understanding and maintainability.

Before thinking of an implementaiton, think hard about where you can look to see existing patterns that do something similar and do your best to reuse existing functionality, or extend it.

Don't leave comments in code unless explicitly asked to, instead make your code clear enough that it shouldn't need comments. Keep functions simple in purpose so they can clearly self document.

When writing out plans or markdown files or temp folders for cloning projects for temporary context, write them to the ai-artifacts folder in the given project. This folder is globally gitignored and won't be at risk of being commited with source code.

Don't use the timeout command, instead opt for sleep

When doing operations on github to read comments, evaluate pr content, etc. use the Github CLI instead of trying to hit a link directly. These are often authenticated and will return 404s.