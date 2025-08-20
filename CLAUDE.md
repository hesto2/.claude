As you implement solutions, keep your implementations as simple as you can make them. Write code that a staff engineer would be impressed with due to its ease of understanding and maintainability.

Before thinking of an implementaiton, think hard about where you can look to see existing patterns that do something similar and do your best to reuse existing functionality, or extend it.

Don't leave comments in code unless explicitly asked to, instead make your code clear enough that it shouldn't need comments. Keep functions simple in purpose so they can clearly self document.

When writing out plans or markdown files or temp folders for cloning projects for temporary context, write them to the ai-artifacts folder in the given project. This folder is globally gitignored and won't be at risk of being commited with source code.

Don't use the timeout command, instead opt for sleep

### Strategy for Extracting Complete Agenda Data

When user requests a comprehensive list of ALL conference sessions:

1. **Challenge:** Page responses exceed token limits (>25000 tokens) when trying to extract all data at once
2. **Solution Strategy:**
   - Filter by individual tracks one at a time to reduce response size
   - Take screenshots of filtered results for visual reference
   - Extract visible session data from the page snapshot when available
   - Manually compile data from multiple filtered views into comprehensive markdown
3. **Key Technical Tracks to Check:**
   - AI Agents [Technical], AI Agents: Strategy, AI Agents: Applications
   - RAG [Technical], RAG & Leveraging Proprietary Data
   - ML Ops & Platforms [Technical], Software Engineering [Technical]
   - Generative Models, Reinforcement Learning, Computer Vision
4. **Data to Extract per Session:**
   - Time slot (start and end time)
   - Session title
   - Speaker(s) and company
   - Room location and level
   - Session type (Workshop, Solo Talk, Roundtable, Keynote)
   - Track assignment
   - Description (if available)
5. **Workaround for Token Limits:**
   - Use `browser_take_screenshot` with fullPage=true for documentation
   - Filter tracks individually rather than viewing all at once
   - Extract data from page snapshots when they're under token limit
   - Create comprehensive markdown file compiling all sessions by day