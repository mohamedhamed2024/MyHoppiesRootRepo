  # AGENTS

<skills_system priority="1">

## Available Skills

<!-- SKILLS_TABLE_START -->
<usage>
When users ask you to perform tasks, check if any of the available skills below can help complete the task more effectively. Skills provide specialized capabilities and domain knowledge.

How to use skills:
- Invoke: `npx openskills read <skill-name>` (run in your shell)
  - For multiple: `npx openskills read skill-one,skill-two`
- The skill content will load with detailed instructions on how to complete the task
- Base directory provided in output for resolving bundled resources (references/, scripts/, assets/)

Usage notes:
- Only use skills listed in <available_skills> below
- Do not invoke a skill that is already loaded in your context
- Each skill invocation is stateless
</usage>

<available_skills>

<skill>
<name>frontend-design</name>
<description>Create distinctive, production-grade frontend interfaces with high design quality. Use this skill when the user asks to build web components, pages, artifacts, posters, or applications (examples include websites, landing pages, dashboards, React components, HTML/CSS layouts, or when styling/beautifying any web UI). Generates creative, polished code and UI design that avoids generic AI aesthetics.</description>
<location>project</location>
</skill>

<skill>
<name>ui-styling</name>
<description>UI and styling conventions for the Ontellus ChartSwap Next.js frontend (`ontellus.chartswap/`). Use when creating or modifying UI components, Tailwind styles, global SCSS overrides, tokens (colors/z-index/spacing), responsive layout, and third-party UI wrappers (react-select, react-datepicker, rc-tooltip, react-toastify).</description>
<location>project</location>
</skill>

<skill>
<name>mcp-builder</name>
<description>Guide for creating high-quality MCP (Model Context Protocol) servers that enable LLMs to interact with external services through well-designed tools. Use when building MCP servers to integrate external APIs or services, whether in Python (FastMCP) or Node/TypeScript (MCP SDK).</description>
<location>project</location>
</skill>

<skill>
<name>nextjs-code-standards</name>
<description>Next.js and React code standards for the ChartSwap new portal (Ontellus ChartSwap). Use when writing or reviewing the new portal frontend (ontellus.chartswap), adding components, implementing state (Zustand), calling Salesforce or .NET APIs, adding a new API integration, writing unit tests, or applying project code style and naming conventions.</description>
<location>project</location>
</skill>

<skill>
<name>skill-creator</name>
<description>Guide for creating effective skills. This skill should be used when users want to create a new skill (or update an existing skill) that extends Claude's capabilities with specialized knowledge, workflows, or tool integrations.</description>
<location>project</location>
</skill>

<!-- Process skills -->
<skill>
<name>product-owner</name>
<description>Act as Product Owner: refine backlog, write user stories and acceptance criteria, prioritize (MoSCoW/RICE), manage scope and stakeholders. Use when the user asks for story writing, backlog refinement, acceptance criteria, prioritization, or roadmap.</description>
<location>project</location>
</skill>

<skill>
<name>scrum-master</name>
<description>Act as Scrum Master: facilitate ceremonies (stand-ups, retros, planning), sprint planning, impediments, process improvement. Use when the user asks for sprint planning, retrospectives, stand-up format, or process facilitation.</description>
<location>project</location>
</skill>

<skill>
<name>tester</name>
<description>Combine QA test planning (strategy, scenarios, test cases, regression/edge coverage, requirements testability review) with browser-style automation using Playwright Test in JavaScript/TypeScript (Next.js-friendly). Use when you need to decide what to test, produce a QA checklist/test cases, and/or create Playwright specs to verify real user flows in a running web app (selectors, screenshots, traces, console logs). For Jest/React Testing Library implementation patterns, refer to nextjs-code-standards.</description>
<location>project</location>
</skill>


<skill>
<name>pr-review</name>
<description>Reviews code and pull requests for correctness, code quality, security, performance, and adherence to Chartswap standards. Use when reviewing pull requests, examining code changes, reviewing individual files, or when the user asks for a code review or PR review.</description>
<location>project</location>
</skill>

</available_skills>
<!-- SKILLS_TABLE_END -->

</skills_system>
