As you implement solutions, keep your implementations as simple as you can make them. Write code that a staff engineer would be impressed with due to its ease of understanding and maintainability.

Before thinking of an implementaiton, think hard about where you can look to see existing patterns that do something similar and do your best to reuse existing functionality, or extend it.

Don't leave comments that are obviously stating what a line of code or a function does. Only use comments for pieces you feel are complicated enough to warrant it.

## Ai4 Conference Agenda Filtering

When filtering the Ai4 conference agenda at https://ai4.io/vegas/agenda/#fullagenda:

1. The agenda page contains an embedded iframe with filters on the left side
2. To filter by track (e.g., "AI Agents [Technical]"):
   - Use Playwright to navigate to the page
   - The filter checkboxes are inside an iframe, so use: `await page.locator('#fullagenda iframe').contentFrame().getByLabel('AI Agents [Technical]').click();`
   - Or click directly on the checkbox element using its ref ID (e.g., f1e1084 for AI Agents [Technical])
3. The page responses can be very large (>25000 tokens), so screenshots are often more practical than full snapshots
4. Filter categories include: Location, All Tracks, Technical Tracks, Industry Tracks, Job Function Tracks, Society Tracks, and Mini-Summits

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