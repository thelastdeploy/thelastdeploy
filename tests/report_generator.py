#!/usr/bin/env python3
"""
tests/report_generator.py
Generates The Last Deploy Hierarchical Regression Dashboard:
  - Tier 1: Master Dashboard (Track Cards only)
  - Tier 2: Track Execution Dashboard (Module Cards for that track)
  - Tier 3: Scoped Module Detailed View (ONLY that module's test cases & console logs)
Built as a unified, client-side Single-Page Application (SPA) in index.html with
hash-based routing (#/track/<track> and #/module/<track>/<module>), making it 100%
compatible with browser sandboxes, flatpaks, document portals, and direct file viewing.
"""

import json
import os
import sys
import re
import html as pyhtml
from collections import defaultdict

# Regex to strip all emojis and pictograms
EMOJI_PATTERN = re.compile(
    r'[\U00010000-\U0010FFFF]'  # SMP emojis and pictograms
    r'|[\u200D\u20E3\uFE0F]'     # Zero-width joiner, enclosing keycaps, variation selectors
    r'|[\u2300-\u23FF]'          # Misc Technical symbols
    r'|[\u2600-\u27BF]'          # Misc Symbols and Dingbats
    r'|[\u2B50\u2B55]'           # Stars and circles
)


def strip_emojis(text: str) -> str:
    """Safely strip all emojis and pictograms from text."""
    if not text:
        return ""
    return EMOJI_PATTERN.sub('', text)


TRACK_ICONS = {
    "linux": '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="4 17 10 11 4 5"></polyline><line x1="12" y1="19" x2="20" y2="19"></line></svg>',
    "docker": '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path></svg>',
    "kubernetes": '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>',
    "k8s": '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>',
    "nginx": '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="2" width="20" height="8" rx="2" ry="2"></rect><rect x="2" y="14" width="20" height="8" rx="2" ry="2"></rect><line x1="6" y1="6" x2="6.01" y2="6"></line><line x1="6" y1="18" x2="6.01" y2="18"></line></svg>',
    "terraform": '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 2 7 12 12 22 7 12 2"></polygon><polyline points="2 17 12 22 22 17"></polyline><polyline points="2 12 12 17 22 12"></polyline></svg>',
    "git": '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="6" y1="3" x2="6" y2="15"></line><circle cx="18" cy="6" r="3"></circle><circle cx="6" cy="18" r="3"></circle><path d="M18 9a9 9 0 0 1-9 9"></path></svg>',
    "bash": '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="4 17 10 11 4 5"></polyline><line x1="12" y1="19" x2="20" y2="19"></line></svg>',
    "security": '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>',
    "storage": '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><ellipse cx="12" cy="5" rx="9" ry="3"></ellipse><path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"></path><path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"></path></svg>',
    "networking": '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="18" cy="5" r="3"></circle><circle cx="6" cy="12" r="3"></circle><circle cx="18" cy="19" r="3"></circle><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"></line><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"></line></svg>',
    "default": '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path><polyline points="3.27 6.96 12 12.01 20.73 6.96"></polyline><line x1="12" y1="22.08" x2="12" y2="12"></line></svg>'
}

TRACK_PRESETS = {
    "linux": {
        "title": "Linux Administration",
        "description": "System fundamentals, shell scripting, process management, storage, networking & security."
    },
    "docker": {
        "title": "Docker & Containers",
        "description": "Container isolation, image optimization, networking, storage & Compose."
    },
    "kubernetes": {
        "title": "Kubernetes & Cloud Native",
        "description": "Pods, deployments, services, storage, and cluster troubleshooting."
    },
    "k8s": {
        "title": "Kubernetes & Cloud Native",
        "description": "Pods, deployments, services, storage, and cluster troubleshooting."
    },
    "nginx": {
        "title": "Nginx & Web Servers",
        "description": "Reverse proxying, load balancing, TLS configuration & security."
    },
    "terraform": {
        "title": "Terraform & IaC",
        "description": "HCL syntax, state management, module architecture & variable scoping."
    },
    "git": {
        "title": "Git & Version Control",
        "description": "Advanced workflows, rebase conflicts, reflog recovery & history rewrites."
    }
}


def get_track_metadata(track_key: str):
    """
    Dynamically returns track title, clean SVG icon, and description.
    Zero emojis. Fully dynamic auto-discovery for any newly added track.
    """
    norm_key = (track_key or "general").strip().lower()
    icon_svg = TRACK_ICONS.get(norm_key, TRACK_ICONS["default"])
    icon_html = f'<span class="track-icon-badge">{icon_svg}</span>'

    if norm_key in TRACK_PRESETS:
        preset = TRACK_PRESETS[norm_key]
        return {
            "title": preset["title"],
            "icon": icon_html,
            "description": preset["description"]
        }

    # Dynamically formatted for ANY newly discovered track
    clean_title = norm_key.replace("-", " ").replace("_", " ").title() + " Track"
    return {
        "title": clean_title,
        "icon": icon_html,
        "description": f"Hands-on scenarios and automated validation for {clean_title}."
    }


def get_shared_css():
    return """
        :root {
            --bg-canvas: #f8fafc;
            --bg-card: #ffffff;
            --border-card: #e2e8f0;
            --border-subtle: #f1f5f9;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --text-dim: #94a3b8;
            --primary-blue: #2563eb;
            --primary-blue-light: #eff6ff;
            --accent-green: #10b981;
            --accent-green-bg: #ecfdf5;
            --accent-red: #f43f5e;
            --accent-red-bg: #fff1f2;
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -2px rgba(0, 0, 0, 0.05);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.05), 0 4px 6px -4px rgba(0, 0, 0, 0.05);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        }

        body {
            background-color: var(--bg-canvas);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .top-navbar {
            background: #ffffff;
            border-bottom: 1px solid var(--border-card);
            padding: 14px 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 50;
        }

        .brand-section {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .brand-icon-box {
            background: #2563eb;
            color: #ffffff;
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 15px;
            box-shadow: 0 2px 4px rgba(37, 99, 235, 0.2);
            cursor: pointer;
        }

        .brand-title-wrap {
            display: flex;
            align-items: baseline;
            gap: 8px;
        }

        .brand-title {
            font-size: 15px;
            font-weight: 600;
            color: var(--text-main);
            letter-spacing: -0.01em;
            text-decoration: none;
            cursor: pointer;
        }

        .brand-version {
            font-size: 11px;
            font-weight: 500;
            color: var(--text-muted);
            background: #f1f5f9;
            padding: 2px 6px;
            border-radius: 4px;
        }

        .nav-meta-section {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .tag-pill {
            font-size: 11px;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 9999px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .tag-pill.gray {
            background: #f1f5f9;
            color: #475569;
        }

        .tag-pill.live {
            background: #ecfdf5;
            color: #059669;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .live-pulse {
            width: 6px;
            height: 6px;
            background: #10b981;
            border-radius: 50%;
            box-shadow: 0 0 0 rgba(16, 185, 129, 0.4);
            animation: pulse-ring 1.8s infinite;
        }

        @keyframes pulse-ring {
            0% { box-shadow: 0 0 0 0 rgba(16, 185, 129, 0.6); }
            70% { box-shadow: 0 0 0 6px rgba(16, 185, 129, 0); }
            100% { box-shadow: 0 0 0 0 rgba(16, 185, 129, 0); }
        }

        .app-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 32px 32px 64px 32px;
            width: 100%;
        }

        /* Breadcrumbs */
        .breadcrumb-bar {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 24px;
            font-size: 13px;
        }

        .breadcrumb-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: #2563eb;
            font-weight: 500;
            cursor: pointer;
            border: none;
            background: none;
            font-size: 13px;
            padding: 0;
        }

        .breadcrumb-btn:hover {
            text-decoration: underline;
        }

        .breadcrumb-separator {
            color: #cbd5e1;
            font-size: 14px;
        }

        .breadcrumb-current {
            color: var(--text-muted);
            font-weight: 500;
        }

        /* Hero Header Card */
        .hero-card {
            background: #ffffff;
            border: 1px solid var(--border-card);
            border-radius: 12px;
            padding: 28px 32px;
            box-shadow: var(--shadow-sm);
            margin-bottom: 24px;
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .hero-left {
            max-width: 800px;
        }

        .eyebrow {
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: #2563eb;
            margin-bottom: 6px;
        }

        .hero-title {
            font-size: 26px;
            font-weight: 700;
            letter-spacing: -0.02em;
            color: var(--text-main);
            margin-bottom: 8px;
        }

        .hero-meta {
            display: flex;
            align-items: center;
            gap: 16px;
            font-size: 13px;
            color: var(--text-muted);
        }

        .meta-item strong {
            color: var(--text-main);
            font-weight: 500;
        }

        /* Status Pills */
        .status-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: 9999px;
            font-size: 12px;
            font-weight: 600;
            letter-spacing: 0.03em;
        }

        .status-pill.passed {
            background: var(--accent-green-bg);
            color: #059669;
            border: 1px solid rgba(16, 185, 129, 0.2);
        }

        .status-pill.failed {
            background: var(--accent-red-bg);
            color: #e11d48;
            border: 1px solid rgba(244, 63, 94, 0.2);
        }

        .pill-dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
        }

        .status-pill.passed .pill-dot {
            background: #10b981;
        }

        .status-pill.failed .pill-dot {
            background: #f43f5e;
        }

        /* Summary Metrics Grid */
        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(6, 1fr);
            gap: 16px;
            margin-bottom: 36px;
        }

        @media (max-width: 1024px) {
            .metrics-grid {
                grid-template-columns: repeat(3, 1fr);
            }
        }

        @media (max-width: 640px) {
            .metrics-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        .metric-card {
            background: #ffffff;
            border: 1px solid var(--border-card);
            border-radius: 10px;
            padding: 18px 20px;
            box-shadow: var(--shadow-sm);
        }

        .metric-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 12px;
        }

        .metric-label {
            font-size: 11px;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.06em;
        }

        .metric-icon {
            color: #94a3b8;
        }

        .metric-val {
            font-size: 30px;
            font-weight: 700;
            color: var(--text-main);
            line-height: 1;
        }

        .metric-val.green { color: #10b981; }
        .metric-val.red { color: #f43f5e; }

        /* Section Headers */
        .section-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }

        .section-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 22px;
            height: 22px;
            color: #64748b;
        }

        .track-icon-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 28px;
            height: 28px;
            border-radius: 6px;
            background: #f1f5f9;
            color: #0284c7;
            vertical-align: middle;
            margin-right: 8px;
            flex-shrink: 0;
        }

        .hero-title .track-icon-badge {
            width: 34px;
            height: 34px;
        }

        .section-title {
            font-size: 18px;
            font-weight: 700;
            letter-spacing: -0.01em;
            color: var(--text-main);
        }

        /* Cards Grid */
        .cards-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 40px;
        }

        @media (max-width: 1100px) {
            .cards-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 700px) {
            .cards-grid {
                grid-template-columns: 1fr;
            }
        }

        .dashboard-card {
            background: #ffffff;
            border: 1px solid var(--border-card);
            border-radius: 12px;
            padding: 24px;
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-direction: column;
            transition: transform 0.15s ease, box-shadow 0.15s ease, border-color 0.15s ease;
            position: relative;
        }

        .dashboard-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
            border-color: #cbd5e1;
        }

        .card-top {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            margin-bottom: 16px;
        }

        .card-eyebrow {
            font-size: 11px;
            font-weight: 700;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 4px;
        }

        .card-heading {
            font-size: 18px;
            font-weight: 700;
            color: var(--text-main);
            letter-spacing: -0.01em;
        }

        .card-progress-bar {
            height: 4px;
            width: 100%;
            background: #f1f5f9;
            border-radius: 9999px;
            overflow: hidden;
            margin-bottom: 20px;
        }

        .card-progress-fill {
            height: 100%;
            border-radius: 9999px;
            transition: width 0.3s ease;
        }

        .card-stats {
            display: flex;
            align-items: baseline;
            justify-content: space-between;
            margin-bottom: 20px;
            flex-grow: 1;
        }

        .stat-group {
            display: flex;
            flex-direction: column;
        }

        .stat-number {
            font-size: 22px;
            font-weight: 700;
            color: var(--text-main);
            line-height: 1.1;
        }

        .stat-sub {
            font-size: 12px;
            color: var(--text-muted);
            margin-top: 3px;
        }

        .card-footer {
            border-top: 1px solid var(--border-subtle);
            padding-top: 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .card-timestamp {
            font-size: 12px;
            color: var(--text-dim);
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .card-btn {
            background: #2563eb;
            color: #ffffff;
            font-size: 13px;
            font-weight: 600;
            padding: 8px 14px;
            border-radius: 6px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            border: none;
            cursor: pointer;
            transition: background 0.15s ease;
        }

        .card-btn:hover {
            background: #1d4ed8;
        }

        /* Filter Tabs & Search Bar */
        .filter-container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
            gap: 16px;
            flex-wrap: wrap;
        }

        .tab-group {
            display: flex;
            align-items: center;
            background: #ffffff;
            border: 1px solid var(--border-card);
            border-radius: 8px;
            padding: 3px;
            gap: 2px;
        }

        .filter-tab {
            border: none;
            background: transparent;
            padding: 6px 14px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            color: var(--text-muted);
            cursor: pointer;
            transition: all 0.15s ease;
        }

        .filter-tab.active {
            background: #f1f5f9;
            color: var(--text-main);
        }

        .filter-tab:hover:not(.active) {
            color: var(--text-main);
        }

        .search-box {
            position: relative;
            max-width: 360px;
            width: 100%;
        }

        .search-input {
            width: 100%;
            padding: 8px 14px 8px 36px;
            font-size: 13px;
            border: 1px solid var(--border-card);
            border-radius: 8px;
            background: #ffffff;
            color: var(--text-main);
            outline: none;
            transition: border-color 0.15s ease, box-shadow 0.15s ease;
        }

        .search-input:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .search-icon-svg {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            pointer-events: none;
        }

        /* Test Cases Table */
        .table-card {
            background: #ffffff;
            border: 1px solid var(--border-card);
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
            overflow: hidden;
            margin-bottom: 32px;
        }

        .test-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        .test-table th {
            background: #f8fafc;
            padding: 12px 20px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            color: var(--text-muted);
            border-bottom: 1px solid var(--border-card);
        }

        .test-table td {
            padding: 14px 20px;
            border-bottom: 1px solid #f1f5f9;
            font-size: 13px;
            vertical-align: middle;
        }

        .test-table tr:hover td {
            background-color: #fafbfc;
        }

        .col-index {
            width: 60px;
            font-weight: 600;
            color: var(--text-dim);
            font-size: 12px;
        }

        .col-status {
            width: 130px;
        }

        .col-flow {
            min-width: 320px;
        }

        .col-duration {
            width: 120px;
            text-align: right;
        }

        .col-action {
            width: 130px;
            text-align: right;
        }

        .test-title {
            font-weight: 600;
            color: var(--text-main);
            margin-bottom: 3px;
        }

        .test-sub {
            font-size: 12px;
            color: var(--text-dim);
            font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
        }

        .duration-chip {
            display: inline-block;
            background: #f1f5f9;
            color: var(--text-muted);
            padding: 3px 8px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }

        .btn-view-log {
            background: #ffffff;
            border: 1px solid var(--border-card);
            padding: 5px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            color: var(--text-muted);
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            transition: all 0.15s ease;
        }

        .btn-view-log:hover {
            color: var(--text-main);
            border-color: #94a3b8;
            background: #f8fafc;
        }

        /* Log Window */
        .log-row td {
            background: #0f172a !important;
            padding: 0 !important;
        }

        .log-terminal {
            background: #090d16;
            color: #e2e8f0;
            font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
            padding: 20px 24px;
            font-size: 12px;
            line-height: 1.6;
            max-height: 480px;
            overflow-y: auto;
            border-top: 1px solid #1e293b;
            border-bottom: 1px solid #1e293b;
            white-space: pre-wrap;
            word-break: break-all;
        }

        .log-bar {
            background: #1e293b;
            padding: 8px 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .mac-dots {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .mac-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
        }

        .mac-red { background: #ef4444; }
        .mac-yellow { background: #eab308; }
        .mac-green { background: #22c55e; }

        .log-title {
            color: #94a3b8;
            font-size: 12px;
            font-weight: 500;
        }

        .btn-close-log {
            background: transparent;
            border: none;
            color: #94a3b8;
            font-size: 12px;
            cursor: pointer;
            padding: 2px 6px;
        }

        .btn-close-log:hover {
            color: #ffffff;
        }
    """


def generate_single_page_app(summary_data, tracks_grouped, report_dir):
    """
    Renders the complete 3-Tier Dashboard inside a single index.html SPA file!
    - Tier 1: view-master (Track Cards)
    - Tier 2: view-track-<track> (Module Cards for that track)
    - Tier 3: view-module-<track>-<module> (Scoped module tests & logs)
    """
    total = summary_data.get("total_test_cases", 0)
    executed = summary_data.get("total_executed", 0)
    passed = summary_data.get("total_passed", 0)
    failed = summary_data.get("total_failed", 0)
    pass_rate = summary_data.get("pass_rate_pct", 0.0)
    duration = summary_data.get("total_duration_sec", 0)
    generated_at = summary_data.get("generated_at", "")
    environment = summary_data.get("environment", "Docker Engine / Linux Container")

    is_overall_passed = failed == 0 and executed > 0
    overall_status = "PASSED" if is_overall_passed else "FAILED"
    overall_class = "passed" if is_overall_passed else "failed"

    # =========================================================================
    # TIER 1: Master View (Track Cards)
    # =========================================================================
    track_cards_html = ""
    for track_key, modules in sorted(tracks_grouped.items()):
        track_meta = get_track_metadata(track_key)

        all_tests = [t for mod in modules.values() for t in mod]
        tr_total = len(all_tests)
        tr_passed = sum(1 for t in all_tests if t.get("status") == "PASSED")
        tr_failed = sum(1 for t in all_tests if t.get("status") == "FAILED")
        tr_duration = sum(t.get("duration_sec", 0) for t in all_tests)
        tr_rate = round((tr_passed / tr_total) * 100, 1) if tr_total > 0 else 0.0
        tr_passed_flag = tr_failed == 0 and tr_total > 0
        tr_status = "PASSED" if tr_passed_flag else "FAILED"
        tr_status_class = "passed" if tr_passed_flag else "failed"
        bar_color = "#10b981" if tr_passed_flag else "#f43f5e"
        mod_count = len(modules)

        track_cards_html += f"""
        <div class="dashboard-card">
            <div class="card-top">
                <div>
                    <div class="card-eyebrow">Track Certification</div>
                    <h3 class="card-heading">{track_meta['icon']} {track_meta['title']}</h3>
                </div>
                <span class="status-pill {tr_status_class}">
                    <span class="pill-dot"></span>
                    {tr_status}
                </span>
            </div>

            <div class="card-progress-bar">
                <div class="card-progress-fill" style="width: {tr_rate}%; background: {bar_color};"></div>
            </div>

            <div class="card-stats">
                <div class="stat-group">
                    <span class="stat-number">{tr_passed}<span style="font-size: 15px; color: var(--text-dim); font-weight: 500;">/{tr_total}</span></span>
                    <span class="stat-sub">Labs Passing ({tr_rate}%)</span>
                </div>
                <div class="stat-group" style="text-align: right;">
                    <span class="stat-number">{mod_count}</span>
                    <span class="stat-sub">Curriculum Modules</span>
                </div>
            </div>

            <div class="card-footer">
                <span class="card-timestamp">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                    Execution: {tr_duration}s
                </span>
                <button onclick="navigateToTrack('{track_key}')" class="card-btn">
                    Explore Track Modules
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                </button>
            </div>
        </div>
        """

    # =========================================================================
    # TIER 2 & TIER 3: Track Views & Scoped Module Views
    # =========================================================================
    track_views_html = ""
    module_views_html = ""

    for track_key, modules in sorted(tracks_grouped.items()):
        track_meta = get_track_metadata(track_key)

        all_tests = [t for mod in modules.values() for t in mod]
        tr_total = len(all_tests)
        tr_passed = sum(1 for t in all_tests if t.get("status") == "PASSED")
        tr_failed = sum(1 for t in all_tests if t.get("status") == "FAILED")
        tr_duration = sum(t.get("duration_sec", 0) for t in all_tests)
        tr_rate = round((tr_passed / tr_total) * 100, 1) if tr_total > 0 else 0.0
        tr_passed_flag = tr_failed == 0 and tr_total > 0
        tr_status = "PASSED" if tr_passed_flag else "FAILED"
        tr_status_class = "passed" if tr_passed_flag else "failed"

        # Build Module Cards for this track
        module_cards_html = ""
        for mod_name, tests in sorted(modules.items()):
            mod_total = len(tests)
            mod_passed = sum(1 for t in tests if t.get("status") == "PASSED")
            mod_failed = sum(1 for t in tests if t.get("status") == "FAILED")
            mod_dur = sum(t.get("duration_sec", 0) for t in tests)
            mod_rate = round((mod_passed / mod_total) * 100, 1) if mod_total > 0 else 0.0
            mod_passed_flag = mod_failed == 0 and mod_total > 0
            mod_status = "PASSED" if mod_passed_flag else "FAILED"
            mod_status_class = "passed" if mod_passed_flag else "failed"
            bar_color = "#10b981" if mod_passed_flag else "#f43f5e"
            display_mod_name = mod_name.replace("_", " ").title()

            module_cards_html += f"""
            <div class="dashboard-card">
                <div class="card-top">
                    <div>
                        <div class="card-eyebrow">Module</div>
                        <h3 class="card-heading">{display_mod_name}</h3>
                    </div>
                    <span class="status-pill {mod_status_class}">
                        <span class="pill-dot"></span>
                        {mod_status}
                    </span>
                </div>

                <div class="card-progress-bar">
                    <div class="card-progress-fill" style="width: {mod_rate}%; background: {bar_color};"></div>
                </div>

                <div class="card-stats">
                    <div class="stat-group">
                        <span class="stat-number">{mod_passed}<span style="font-size: 15px; color: var(--text-dim); font-weight: 500;">/{mod_total}</span></span>
                        <span class="stat-sub">Tests Passed ({mod_rate}%)</span>
                    </div>
                    <div class="stat-group" style="text-align: right;">
                        <span class="stat-number">{mod_dur}s</span>
                        <span class="stat-sub">Execution Time</span>
                    </div>
                </div>

                <div class="card-footer">
                    <span class="card-timestamp">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                        {generated_at}
                    </span>
                    <button onclick="navigateToModule('{track_key}', '{mod_name}')" class="card-btn">
                        View Detailed Report
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                    </button>
                </div>
            </div>
            """

            # Build Scoped View for this specific module
            rows_html = ""
            for idx, t in enumerate(tests, 1):
                st = t.get("status", "FAILED")
                st_class = "passed" if st == "PASSED" else "failed"
                dur = t.get("duration_sec", 0)
                path = t.get("test_path", "")
                lab_id = t.get("lab_id", "")
                display_title = lab_id if lab_id else path.split("/")[-1]

                log_file = t.get("log_file", "")
                abs_log_path = os.path.join(report_dir, log_file)
                log_content = ""
                if os.path.exists(abs_log_path):
                    with open(abs_log_path, "r", encoding="utf-8", errors="ignore") as lf:
                        log_content = lf.read()
                safe_log = pyhtml.escape(strip_emojis(log_content))

                rows_html += f"""
                <tr class="test-row mod-{mod_name}" data-status="{st}" data-search="{display_title.lower()} {path.lower()}">
                    <td class="col-index">#{idx:02d}</td>
                    <td class="col-status">
                        <span class="status-pill {st_class}">
                            <span class="pill-dot"></span>
                            {st}
                        </span>
                    </td>
                    <td class="col-flow">
                        <div class="test-title">{display_title}</div>
                        <div class="test-sub">{path}</div>
                    </td>
                    <td class="col-duration">
                        <span class="duration-chip">{dur}s</span>
                    </td>
                    <td class="col-action">
                        <button class="btn-view-log" onclick="toggleLog('{track_key}-{mod_name}-{idx}')">
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="4 17 10 11 4 5"></polyline><line x1="12" y1="19" x2="20" y2="19"></line></svg>
                            View Log
                        </button>
                    </td>
                </tr>
                <tr id="log-row-{track_key}-{mod_name}-{idx}" class="log-row" style="display: none;">
                    <td colspan="5">
                        <div class="log-bar">
                            <div class="mac-dots">
                                <span class="mac-dot mac-red"></span>
                                <span class="mac-dot mac-yellow"></span>
                                <span class="mac-dot mac-green"></span>
                            </div>
                            <span class="log-title">Console Output: #{idx:02d} &mdash; {lab_id}</span>
                            <button class="btn-close-log" onclick="toggleLog('{track_key}-{mod_name}-{idx}')">Close &times;</button>
                        </div>
                        <pre class="log-terminal">{safe_log}</pre>
                    </td>
                </tr>
                """

            module_views_html += f"""
            <div id="view-module-{track_key}-{mod_name}" class="spa-view" style="display: none;">
                <!-- Breadcrumbs -->
                <div class="breadcrumb-bar">
                    <button onclick="navigateToMaster()" class="breadcrumb-btn">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                        Master Regression Dashboard
                    </button>
                    <span class="breadcrumb-separator">/</span>
                    <button onclick="navigateToTrack('{track_key}')" class="breadcrumb-btn">{track_meta['title']}</button>
                    <span class="breadcrumb-separator">/</span>
                    <span class="breadcrumb-current">{display_mod_name}</span>
                </div>

                <!-- Scoped Module Header -->
                <div class="hero-card" style="border-left: 5px solid {'#10b981' if mod_passed_flag else '#f43f5e'};">
                    <div class="hero-left">
                        <div class="eyebrow">Module Execution Report</div>
                        <h1 class="hero-title">{display_mod_name}</h1>
                        <div class="hero-meta">
                            <span class="meta-item">Last Executed: <strong>{generated_at}</strong></span>
                            <span>&bull;</span>
                            <span class="meta-item">Environment: <strong>{environment}</strong></span>
                        </div>
                    </div>
                    <div class="status-pill {mod_status_class}" style="padding: 10px 20px; font-size: 14px;">
                        <span class="pill-dot" style="width: 8px; height: 8px;"></span>
                        {mod_status}
                    </div>
                </div>

                <!-- Scoped Metrics Grid -->
                <div class="metrics-grid">
                    <div class="metric-card">
                        <div class="metric-top"><span class="metric-label">Module Test Cases</span></div>
                        <div class="metric-val">{mod_total}</div>
                    </div>
                    <div class="metric-card">
                        <div class="metric-top"><span class="metric-label">Passed</span></div>
                        <div class="metric-val green">{mod_passed}</div>
                    </div>
                    <div class="metric-card">
                        <div class="metric-top"><span class="metric-label">Failed</span></div>
                        <div class="metric-val red">{mod_failed}</div>
                    </div>
                    <div class="metric-card">
                        <div class="metric-top"><span class="metric-label">Pass Rate</span></div>
                        <div class="metric-val">{mod_rate}%</div>
                    </div>
                    <div class="metric-card">
                        <div class="metric-top"><span class="metric-label">Execution Time</span></div>
                        <div class="metric-val">{mod_dur}s</div>
                    </div>
                    <div class="metric-card">
                        <div class="metric-top"><span class="metric-label">Pending</span></div>
                        <div class="metric-val" style="color: #94a3b8;">0</div>
                    </div>
                </div>

                <!-- Scoped Filter & Search -->
                <div class="filter-container">
                    <div class="tab-group">
                        <button class="filter-tab active" onclick="filterModuleTable('{track_key}-{mod_name}', 'all', this)">All ({mod_total})</button>
                        <button class="filter-tab" onclick="filterModuleTable('{track_key}-{mod_name}', 'PASSED', this)">Passed ({mod_passed})</button>
                        <button class="filter-tab" onclick="filterModuleTable('{track_key}-{mod_name}', 'FAILED', this)">Failed ({mod_failed})</button>
                    </div>
                    <div class="search-box">
                        <svg class="search-icon-svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                        <input type="text" class="search-input" placeholder="Search test cases or lab id..." onkeyup="searchModuleTable('{track_key}-{mod_name}', this.value)">
                    </div>
                </div>

                <!-- Scoped Test Table -->
                <div class="table-card">
                    <table class="test-table">
                        <thead>
                            <tr>
                                <th class="col-index">#</th>
                                <th class="col-status">Status</th>
                                <th class="col-flow">Test Flow / Scenario</th>
                                <th class="col-duration">Duration</th>
                                <th class="col-action">Console</th>
                            </tr>
                        </thead>
                        <tbody id="table-body-{track_key}-{mod_name}">
                            {rows_html}
                        </tbody>
                    </table>
                </div>
            </div>
            """

        track_views_html += f"""
        <div id="view-track-{track_key}" class="spa-view" style="display: none;">
            <!-- Breadcrumbs -->
            <div class="breadcrumb-bar">
                <button onclick="navigateToMaster()" class="breadcrumb-btn">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                    Master Regression Dashboard
                </button>
                <span class="breadcrumb-separator">/</span>
                <span class="breadcrumb-current">{track_meta['title']}</span>
            </div>

            <!-- Track Hero Card -->
            <div class="hero-card" style="border-left: 5px solid {'#10b981' if tr_passed_flag else '#f43f5e'};">
                <div class="hero-left">
                    <div class="eyebrow">Track Execution Report</div>
                    <h1 class="hero-title">{track_meta['icon']} {track_meta['title']}</h1>
                    <div class="hero-meta">
                        <span class="meta-item">Last Executed: <strong>{generated_at}</strong></span>
                        <span>&bull;</span>
                        <span class="meta-item">Environment: <strong>{environment}</strong></span>
                    </div>
                </div>
                <div class="status-pill {tr_status_class}" style="padding: 10px 20px; font-size: 14px;">
                    <span class="pill-dot" style="width: 8px; height: 8px;"></span>
                    {tr_status}
                </div>
            </div>

            <!-- Track Metrics Grid -->
            <div class="metrics-grid">
                <div class="metric-card">
                    <div class="metric-top"><span class="metric-label">Track Test Cases</span></div>
                    <div class="metric-val">{tr_total}</div>
                </div>
                <div class="metric-card">
                    <div class="metric-top"><span class="metric-label">Passed</span></div>
                    <div class="metric-val green">{tr_passed}</div>
                </div>
                <div class="metric-card">
                    <div class="metric-top"><span class="metric-label">Failed</span></div>
                    <div class="metric-val red">{tr_failed}</div>
                </div>
                <div class="metric-card">
                    <div class="metric-top"><span class="metric-label">Pass Rate</span></div>
                    <div class="metric-val">{tr_rate}%</div>
                </div>
                <div class="metric-card">
                    <div class="metric-top"><span class="metric-label">Total Duration</span></div>
                    <div class="metric-val">{tr_duration}s</div>
                </div>
                <div class="metric-card">
                    <div class="metric-top"><span class="metric-label">Modules</span></div>
                    <div class="metric-val">{len(modules)}</div>
                </div>
            </div>

            <!-- Modules Section Header -->
            <div class="section-header">
                <span class="section-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg></span>
                <h2 class="section-title">Modules in this Track</h2>
            </div>

            <!-- Module Cards Grid -->
            <div class="cards-grid">
                {module_cards_html}
            </div>
        </div>
        """

    full_html = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>The Last Deploy &mdash; Master Regression Dashboard</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        {get_shared_css()}
    </style>
</head>
<body>
    <header class="top-navbar">
        <div class="brand-section">
            <div class="brand-icon-box" onclick="navigateToMaster()">&gt;_</div>
            <div class="brand-title-wrap">
                <span onclick="navigateToMaster()" class="brand-title">The Last Deploy &mdash; Regression Suite</span>
                <span class="brand-version">v1.4</span>
            </div>
        </div>
        <div class="nav-meta-section">
            <span class="tag-pill live"><span class="live-pulse"></span> LIVE AUTO-UPDATE</span>
            <span class="tag-pill gray">LOCAL DEV ENGINE</span>
            <span class="tag-pill gray">Runner: tld-dev</span>
        </div>
    </header>

    <main class="app-container">
        <!-- TIER 1: Master Dashboard (Track Cards Only) -->
        <div id="view-master">
            <div class="hero-card" style="border-left: 5px solid {'#10b981' if is_overall_passed else '#f43f5e'};">
                <div class="hero-left">
                    <div class="eyebrow">Master Test Suite</div>
                    <h1 class="hero-title">The Last Deploy Master Regression Dashboard</h1>
                    <div class="hero-meta">
                        <span class="meta-item">Generated: <strong>{generated_at}</strong></span>
                        <span>&bull;</span>
                        <span class="meta-item">Environment: <strong>{environment}</strong></span>
                    </div>
                </div>
                <div class="status-pill {overall_class}" style="padding: 10px 20px; font-size: 14px;">
                    <span class="pill-dot" style="width: 8px; height: 8px;"></span>
                    {overall_status}
                </div>
            </div>

            <!-- 6 Metrics Grid -->
            <div class="metrics-grid">
                <div class="metric-card">
                    <div class="metric-top">
                        <span class="metric-label">Total System Tests</span>
                        <svg class="metric-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>
                    </div>
                    <div class="metric-val">{total}</div>
                </div>
                <div class="metric-card">
                    <div class="metric-top">
                        <span class="metric-label">Total Executed</span>
                        <svg class="metric-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polygon points="10 8 16 12 10 16 10 8"></polygon></svg>
                    </div>
                    <div class="metric-val">{executed}</div>
                </div>
                <div class="metric-card">
                    <div class="metric-top">
                        <span class="metric-label">Total Passed</span>
                        <svg class="metric-icon" style="color: #10b981;" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                    </div>
                    <div class="metric-val green">{passed}</div>
                </div>
                <div class="metric-card">
                    <div class="metric-top">
                        <span class="metric-label">Total Failed</span>
                        <svg class="metric-icon" style="color: #f43f5e;" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>
                    </div>
                    <div class="metric-val red">{failed}</div>
                </div>
                <div class="metric-card">
                    <div class="metric-top">
                        <span class="metric-label">Pass Rate</span>
                        <svg class="metric-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="19" y1="5" x2="5" y2="19"></line><circle cx="6.5" cy="6.5" r="2.5"></circle><circle cx="17.5" cy="17.5" r="2.5"></circle></svg>
                    </div>
                    <div class="metric-val">{pass_rate}%</div>
                </div>
                <div class="metric-card">
                    <div class="metric-top">
                        <span class="metric-label">Total Duration</span>
                        <svg class="metric-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                    </div>
                    <div class="metric-val">{duration}s</div>
                </div>
            </div>

            <!-- Section: Track Cards Only -->
            <div class="section-header">
                <span class="section-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg></span>
                <h2 class="section-title">Active Certification Tracks</h2>
            </div>
            <div class="cards-grid">
                {track_cards_html}
            </div>
        </div>

        <!-- TIER 2: Track Execution Dashboards (One per track) -->
        {track_views_html}

        <!-- TIER 3: Scoped Module Detailed Views (One per module) -->
        {module_views_html}
    </main>

    <script>
        // SPA View Router Engine
        function showView(viewId) {{
            document.getElementById('view-master').style.display = 'none';
            document.querySelectorAll('.spa-view').forEach(v => v.style.display = 'none');
            const target = document.getElementById(viewId);
            if (target) {{
                target.style.display = 'block';
                window.scrollTo(0, 0);
            }}
        }}

        function navigateToMaster() {{
            window.location.hash = '#/';
            showView('view-master');
        }}

        function navigateToTrack(trackKey) {{
            window.location.hash = '#/track/' + trackKey;
            showView('view-track-' + trackKey);
        }}

        function navigateToModule(trackKey, modName) {{
            window.location.hash = '#/module/' + trackKey + '/' + modName;
            showView('view-module-' + trackKey + '-' + modName);
        }}

        function toggleLog(uniqueId) {{
            const row = document.getElementById('log-row-' + uniqueId);
            if (row) {{
                row.style.display = (row.style.display === 'none') ? 'table-row' : 'none';
            }}
        }}

        function filterModuleTable(scopeId, status, btn) {{
            const tbody = document.getElementById('table-body-' + scopeId);
            const parentGroup = btn.parentElement;
            parentGroup.querySelectorAll('.filter-tab').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');

            const rows = tbody.querySelectorAll('.test-row');
            rows.forEach(r => {{
                const st = r.getAttribute('data-status');
                const logRow = r.nextElementSibling;
                if (status === 'all' || st === status) {{
                    r.style.display = 'table-row';
                }} else {{
                    r.style.display = 'none';
                    if (logRow && logRow.classList.contains('log-row')) {{
                        logRow.style.display = 'none';
                    }}
                }}
            }});
        }}

        function searchModuleTable(scopeId, query) {{
            const tbody = document.getElementById('table-body-' + scopeId);
            const q = query.toLowerCase().trim();
            const rows = tbody.querySelectorAll('.test-row');

            rows.forEach(r => {{
                const text = r.getAttribute('data-search') || '';
                const logRow = r.nextElementSibling;
                if (text.includes(q)) {{
                    r.style.display = 'table-row';
                }} else {{
                    r.style.display = 'none';
                    if (logRow && logRow.classList.contains('log-row')) {{
                        logRow.style.display = 'none';
                    }}
                }}
            }});
        }}

        // Hash Routing Listener (Supports Back/Forward Buttons & Deep Links)
        function handleHashRouting() {{
            const hash = window.location.hash;
            if (!hash || hash === '#/' || hash === '#' || hash === '') {{
                showView('view-master');
            }} else if (hash.startsWith('#/track/')) {{
                const trackKey = hash.replace('#/track/', '');
                showView('view-track-' + trackKey);
            }} else if (hash.startsWith('#/module/')) {{
                const parts = hash.replace('#/module/', '').split('/');
                if (parts.length >= 2) {{
                    showView('view-module-' + parts[0] + '-' + parts[1]);
                }}
            }}
        }}

        window.addEventListener('hashchange', handleHashRouting);
        window.addEventListener('DOMContentLoaded', handleHashRouting);

        // Real-time automatic polling
        let currentTimestamp = "";
        async function checkLiveUpdates() {{
            try {{
                const res = await fetch('summary.json?t=' + Date.now());
                if (res.ok) {{
                    const data = await res.json();
                    const newTs = data.generated_at || "";
                    if (currentTimestamp === "") {{
                        currentTimestamp = newTs;
                    }} else if (currentTimestamp !== newTs) {{
                        window.location.reload();
                    }}
                }}
            }} catch (e) {{}}
        }}
        setInterval(checkLiveUpdates, 3000);
    </script>
</body>
</html>
"""
    out_file = os.path.join(report_dir, "index.html")
    with open(out_file, "w", encoding="utf-8") as f:
        f.write(full_html)


def generate_all_dashboards(summary_file):
    report_dir = os.path.dirname(os.path.abspath(summary_file))

    with open(summary_file, "r", encoding="utf-8") as f:
        summary_data = json.load(f)

    # Automatically scan for and merge any additional track summary files in report_dir
    results_map = {r.get("test_path"): r for r in summary_data.get("results", []) if r.get("test_path")}
    for root, dirs, files in os.walk(report_dir):
        for file in files:
            if file == "summary.json":
                sub_path = os.path.join(root, file)
                if os.path.abspath(sub_path) == os.path.abspath(summary_file):
                    continue
                try:
                    with open(sub_path, "r", encoding="utf-8") as sf:
                        sub_data = json.load(sf)
                        for r in sub_data.get("results", []):
                            tp = r.get("test_path")
                            if tp and tp not in results_map:
                                results_map[tp] = r
                except Exception:
                    pass

    all_results = list(results_map.values())
    summary_data["results"] = all_results
    summary_data["total_test_cases"] = len(all_results)
    summary_data["total_executed"] = len(all_results)
    summary_data["total_passed"] = sum(1 for r in all_results if r.get("status") == "PASSED")
    summary_data["total_failed"] = sum(1 for r in all_results if r.get("status") == "FAILED")
    summary_data["pass_rate_pct"] = round((summary_data["total_passed"] / len(all_results)) * 100, 1) if all_results else 0.0

    # Group by track and module
    tracks_grouped = defaultdict(lambda: defaultdict(list))
    for res in all_results:
        t = res.get("track", "general").strip().lower()
        m = res.get("module", "default").strip().lower()
        tracks_grouped[t][m].append(res)

    # Generate unified SPA in index.html
    generate_single_page_app(summary_data, tracks_grouped, report_dir)

    print(f"Master Regression Dashboard (SPA): file://{os.path.join(report_dir, 'index.html')}")


def main():
    if len(sys.argv) < 2:
        default_summary = os.path.join(os.path.dirname(os.path.abspath(__file__)), "reports", "summary.json")
        if os.path.isfile(default_summary):
            summary_file = default_summary
        else:
            print("Usage: python3 report_generator.py <path_to_summary.json>")
            sys.exit(1)
    else:
        summary_file = sys.argv[1]

    if not os.path.isfile(summary_file):
        print(f"Error: {summary_file} not found.")
        sys.exit(1)

    generate_all_dashboards(summary_file)


if __name__ == "__main__":
    main()
