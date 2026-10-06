---
title: "Frontend Dashboard Architecture"
description: "Next.js learning dashboard layout, component hierarchy, and interactive code editors."
section: "Architecture"
---

The TLD Frontend (`web/frontend/`) is a Next.js 16 (App Router) web application running on port 9000. It serves as the primary portal where users browse modules, attempt reading sections, view leaderboards, and manage CLI devices.

## Technology Stack

* **Framework:** Next.js 16 (App Router), React 19
* **Styling & UI:** TailwindCSS v4, Radix UI primitives, Lucide React icons
* **Code Editor:** CodeMirror 6 (`@uiw/react-codemirror` with One Dark theme)
* **Markdown Rendering:** `react-markdown` + `remark-gfm`

## Application Routes (`web/frontend/app/`)

* `app/page.tsx`: Landing view and track catalog summary.
* `app/modules/page.tsx`: Filterable grid of all published learning modules and tracks.
* `app/modules/[moduleId]/[sectionId]/page.tsx`: Interactive lesson viewer. Renders markdown content and tracks section reading progress.
* `app/dashboard/page.tsx`: User stats, XP progress chart, streak counter, and recent lab completions.
* `app/builder/page.tsx`: Maintainer IDE for creating and editing module manifests (`module.yaml`), scenario READMEs, and `validator.sh` scripts.
* `app/cli/page.tsx`: Device pairing page handling `tld login` browser authorizations.

## Reading Completion Tracking

When a user opens a lesson section (`/modules/[moduleId]/[sectionId]`), the frontend attaches a scroll listener to the article container. When the scroll position reaches the end of the text, a `POST /api/v1/modules/{moduleId}/sections/{sectionId}/complete` request is sent to the backend to mark the section complete and award section XP.