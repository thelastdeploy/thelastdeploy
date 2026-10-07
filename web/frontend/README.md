# TLD Web Dashboard (`web/frontend`)

The web frontend for **The Last Deploy** — an interactive dashboard for managing user accounts, tracking lab progress, viewing global leaderboards, and exploring DevOps learning paths.

## Tech Stack

- **Framework**: Next.js 15 (App Router, React 19)
- **Styling**: Tailwind CSS, Vanilla CSS Design System (Light/Dark mode)
- **Icons & Visuals**: Lucide Icons, Mermaid.js, Dynamic Theme System
- **State & API Integration**: Next.js Client & Server Components, Axios / Fetch API connected to FastAPI backend (`http://localhost:9001`)

---

## Local Development

### 1 — Isolated Docker Setup (Recommended)

Run the frontend together with PostgreSQL, FastAPI backend, and Landing/Docs using the root Makefile:

```bash
# From repository root:
make dev-up
```

Access the frontend at: **[http://localhost:9000](http://localhost:9000)**

---

### 2 — Standalone Local Execution

```bash
# Install dependencies
npm install

# Run dev server on port 9000 (or default 3000)
npm run dev
```

### Environment Variables (`.env.local`)

```env
NEXT_PUBLIC_API_URL=http://localhost:9001
NEXT_PUBLIC_LANDING_URL=http://localhost:9002
```

---

## Scripts

- `npm run dev` — Start Next.js development server
- `npm run build` — Build production bundle
- `npm run start` — Run production server
- `npm run lint` — Run ESLint code checks
