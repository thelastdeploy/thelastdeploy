#!/usr/bin/env python3
"""
tests/report_generator.py
Generates the DevLab Master Regression Dashboard and Track Execution Reports
as a high-end, state-of-the-art Single-Page Application (SPA) dashboard.
"""

import json
import os
import sys
import html as pyhtml
from collections import defaultdict


def generate_single_page_dashboard(summary_data, report_dir):
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
    status_bg = "#10b981" if is_overall_passed else "#f43f5e"
    status_light_bg = "rgba(16, 185, 129, 0.1)" if is_overall_passed else "rgba(244, 63, 94, 0.1)"
    status_text_color = "#059669" if is_overall_passed else "#e11d48"
    accent_bar = "#10b981" if is_overall_passed else "#f43f5e"

    # Group by track and module
    tracks = defaultdict(lambda: defaultdict(list))
    for res in summary_data.get("results", []):
        t = res.get("track", "general")
        m = res.get("module", "default")
        tracks[t][m].append(res)

    # 1. Build Master View Track Cards
    track_sections_html = ""
    for track_name, modules in tracks.items():
        track_sections_html += f"""
        <div class="track-section">
            <div class="track-header">
                <div class="track-badge-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect><line x1="8" y1="21" x2="16" y2="21"></line><line x1="12" y1="17" x2="12" y2="21"></line></svg>
                </div>
                <h2 class="track-title">Track: <span style="text-transform: capitalize;">{track_name}</span></h2>
            </div>
            <div class="modules-grid">
        """
        for mod_name, tests in modules.items():
            mod_total = len(tests)
            mod_passed = sum(1 for t in tests if t["status"] == "PASSED")
            mod_failed = sum(1 for t in tests if t["status"] == "FAILED")
            mod_duration = sum(t.get("duration_sec", 0) for t in tests)
            mod_status = "PASSED" if mod_failed == 0 else "FAILED"
            badge_class = "badge-pass" if mod_failed == 0 else "badge-fail"
            pct = round((mod_passed / mod_total) * 100, 1) if mod_total > 0 else 0
            progress_bar_color = "#10b981" if mod_failed == 0 else "#f43f5e"

            display_mod_name = mod_name.replace("_", " ").title()

            track_sections_html += f"""
                <div class="module-card">
                    <div class="card-header">
                        <div class="module-meta">
                            <span class="module-eyebrow">Module</span>
                            <h3 class="card-title">{display_mod_name}</h3>
                        </div>
                        <span class="status-pill {badge_class}">
                            <span class="pulsing-dot"></span>
                            {mod_status}
                        </span>
                    </div>

                    <!-- Visual Progress Bar -->
                    <div class="progress-container">
                        <div class="progress-bar-bg">
                            <div class="progress-bar-fill" style="width: {pct}%; background: {progress_bar_color};"></div>
                        </div>
                    </div>

                    <div class="card-body">
                        <div class="card-metric">
                            <span class="metric-big">{mod_passed}<span class="metric-total">/{mod_total}</span></span>
                            <span class="metric-sub">Tests Passed ({pct}%)</span>
                        </div>
                        <div class="card-metric" style="text-align: right;">
                            <span class="metric-big">{mod_duration}s</span>
                            <span class="metric-sub">Execution Time</span>
                        </div>
                    </div>

                    <div class="card-footer">
                        <span class="timestamp">
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="margin-right: 4px; vertical-align: -1px;"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                            {generated_at}
                        </span>
                        <button onclick="showTrackDetail('{track_name}', '{mod_name}')" class="btn-detail">
                            View Detailed Report
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" class="arrow-icon"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                        </button>
                    </div>
                </div>
            """
        track_sections_html += "</div></div>"

    # 2. Build Track Detail Views (Embedded)
    track_details_html = ""
    for track_name, modules in tracks.items():
        track_tests = [t for mod in modules.values() for t in mod]
        tr_total = len(track_tests)
        tr_passed = sum(1 for t in track_tests if t["status"] == "PASSED")
        tr_failed = sum(1 for t in track_tests if t["status"] == "FAILED")
        tr_duration = sum(t.get("duration_sec", 0) for t in track_tests)
        tr_pass_rate = round((tr_passed / tr_total) * 100, 1) if tr_total > 0 else 0
        tr_status = "PASSED" if tr_failed == 0 else "FAILED"
        tr_badge_class = "badge-pass" if tr_failed == 0 else "badge-fail"
        tr_accent = "#10b981" if tr_failed == 0 else "#f43f5e"

        rows_html = ""
        for idx, t in enumerate(track_tests, 1):
            st = t["status"]
            dur = t.get("duration_sec", 0)
            path = t["test_path"]
            lab_id = t.get("lab_id", "")
            badge_class = "badge-pass" if st == "PASSED" else "badge-fail"

            # Parse path into readable components
            # Example path: linux/linux_fundamentals/02_terminal_basics/lnx_open_terminal/positive/student_creates_terminal_ready.sh
            path_parts = path.split("/")
            display_title = lab_id if lab_id else path_parts[-1]
            sub_path = "/".join(path_parts[:-1]) if len(path_parts) > 1 else path

            abs_log_path = os.path.join(report_dir, t["log_file"])
            log_content = ""
            if os.path.exists(abs_log_path):
                with open(abs_log_path, "r", encoding="utf-8", errors="ignore") as lf:
                    log_content = lf.read()
            safe_log = pyhtml.escape(log_content)

            rows_html += f"""
            <tr class="test-row" data-status="{st}" data-path="{path.lower()}">
                <td class="col-num">#{idx:02d}</td>
                <td class="col-status">
                    <span class="status-pill {badge_class}">
                        <span class="pulsing-dot"></span>
                        {st}
                    </span>
                </td>
                <td class="col-path">
                    <div class="test-path-wrapper">
                        <div class="test-primary-name">{display_title}</div>
                        <div class="test-sub-path">{path}</div>
                    </div>
                </td>
                <td class="col-duration">
                    <span class="duration-badge">{dur}s</span>
                </td>
                <td class="col-action">
                    <button class="btn-log" onclick="toggleLog('{track_name}-{idx}')">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="margin-right: 5px;"><polyline points="4 17 10 11 4 5"></polyline><line x1="12" y1="19" x2="20" y2="19"></line></svg>
                        View Log
                    </button>
                </td>
            </tr>
            <tr id="log-row-{track_name}-{idx}" class="log-row" style="display: none;">
                <td colspan="5" class="log-td">
                    <div class="log-window">
                        <div class="log-window-bar">
                            <div class="mac-dots">
                                <span class="dot dot-red"></span>
                                <span class="dot dot-yellow"></span>
                                <span class="dot dot-green"></span>
                            </div>
                            <span class="log-window-title">Console Output: #{idx} &mdash; {lab_id}</span>
                            <div class="log-window-actions">
                                <button class="btn-close-log" onclick="toggleLog('{track_name}-{idx}')">Close &times;</button>
                            </div>
                        </div>
                        <pre class="log-content">{safe_log}</pre>
                    </div>
                </td>
            </tr>
            """

        track_details_html += f"""
        <div id="track-view-{track_name}" class="track-detail-view" style="display: none;">
            <!-- Breadcrumb Navigation -->
            <div class="breadcrumb-bar">
                <button onclick="showMasterDashboard()" class="breadcrumb-btn">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 6px;"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                    Master Regression Dashboard
                </button>
                <span class="breadcrumb-separator">/</span>
                <span class="breadcrumb-current" style="text-transform: capitalize;">{track_name} Track</span>
            </div>

            <div class="header-card" style="border-left: 5px solid {tr_accent};">
                <div>
                    <div class="eyebrow-tag">Execution Breakdown</div>
                    <h1 class="header-title" style="text-transform: capitalize;">{track_name} Track Execution Report</h1>
                    <div class="header-meta">
                        <span>Last Executed: <strong>{generated_at}</strong></span>
                        <span class="meta-dot">&bull;</span>
                        <span>Environment: <strong>{environment}</strong></span>
                    </div>
                </div>
                <div class="status-pill-large {tr_badge_class}">
                    <span class="pulsing-dot-large"></span>
                    {tr_status}
                </div>
            </div>

            <div class="metrics-grid">
                <div class="metric-card">
                    <div class="metric-card-top">
                        <span class="metric-label">Total Test Cases</span>
                        <svg class="metric-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                    </div>
                    <div class="metric-value">{tr_total}</div>
                </div>
                <div class="metric-card">
                    <div class="metric-card-top">
                        <span class="metric-label">Passed</span>
                        <svg class="metric-icon" style="color: #10b981;" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                    </div>
                    <div class="metric-value passed">{tr_passed}</div>
                </div>
                <div class="metric-card">
                    <div class="metric-card-top">
                        <span class="metric-label">Failed</span>
                        <svg class="metric-icon" style="color: #f43f5e;" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>
                    </div>
                    <div class="metric-value failed">{tr_failed}</div>
                </div>
                <div class="metric-card">
                    <div class="metric-card-top">
                        <span class="metric-label">Not Run / Pending</span>
                        <svg class="metric-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 14 14"></polyline></svg>
                    </div>
                    <div class="metric-value" style="color: #94a3b8;">0</div>
                </div>
                <div class="metric-card">
                    <div class="metric-card-top">
                        <span class="metric-label">Pass Rate</span>
                        <svg class="metric-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="19" y1="5" x2="5" y2="19"></line><circle cx="6.5" cy="6.5" r="2.5"></circle><circle cx="17.5" cy="17.5" r="2.5"></circle></svg>
                    </div>
                    <div class="metric-value">{tr_pass_rate}%</div>
                </div>
                <div class="metric-card">
                    <div class="metric-card-top">
                        <span class="metric-label">Total Duration</span>
                        <svg class="metric-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                    </div>
                    <div class="metric-value">{tr_duration}s</div>
                </div>
            </div>

            <!-- Filter & Search Toolbar -->
            <div class="filter-toolbar">
                <div class="filter-tabs">
                    <button class="tab-btn active" onclick="filterTable('{track_name}', 'all')">
                        All <span class="tab-count">{tr_total}</span>
                    </button>
                    <button class="tab-btn" onclick="filterTable('{track_name}', 'PASSED')">
                        Passed <span class="tab-count count-passed">{tr_passed}</span>
                    </button>
                    <button class="tab-btn" onclick="filterTable('{track_name}', 'FAILED')">
                        Failed <span class="tab-count count-failed">{tr_failed}</span>
                    </button>
                </div>
                <div class="search-box-wrapper">
                    <svg class="search-icon" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                    <input type="text" id="searchInput-{track_name}" class="search-input" placeholder="Search test case, lab id, or file path..." onkeyup="searchTable('{track_name}')">
                </div>
            </div>

            <!-- Test Cases Table -->
            <div class="table-card">
                <table>
                    <thead>
                        <tr>
                            <th style="width: 70px;">#</th>
                            <th style="width: 140px;">Status</th>
                            <th>Test Flow / Scenario</th>
                            <th style="width: 110px;">Duration</th>
                            <th style="width: 130px; text-align: center;">Console</th>
                        </tr>
                    </thead>
                    <tbody id="testTableBody-{track_name}">
                        {rows_html}
                    </tbody>
                </table>
            </div>
        </div>
        """

    full_html = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>The Last Deploy — Automated Regression Suite</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {{
            --bg: #f8fafc;
            --card-bg: #ffffff;
            --text-main: #0f172a;
            --text-sub: #64748b;
            --border: #e2e8f0;
            --primary: #2563eb;
            --primary-hover: #1d4ed8;
            --primary-light: #eff6ff;
            --success: #10b981;
            --success-light: #ecfdf5;
            --danger: #f43f5e;
            --danger-light: #fff1f2;
            --card-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.04), 0 1px 2px -1px rgb(0 0 0 / 0.04);
            --card-shadow-hover: 0 10px 15px -3px rgb(0 0 0 / 0.07), 0 4px 6px -4px rgb(0 0 0 / 0.05);
        }}
        * {{ box-sizing: border-box; margin: 0; padding: 0; }}
        body {{
            background: var(--bg);
            color: var(--text-main);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            padding: 32px 48px;
            -webkit-font-smoothing: antialiased;
        }}
        .container {{ max-width: 1360px; margin: 0 auto; }}

        /* Top Brand Navigation */
        .top-navbar {{
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 1px solid var(--border);
        }}
        .brand-box {{ display: flex; align-items: center; gap: 10px; }}
        .brand-logo {{
            width: 32px;
            height: 32px;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            box-shadow: 0 2px 4px rgba(37, 99, 235, 0.25);
        }}
        .brand-name {{ font-size: 15px; font-weight: 700; color: #0f172a; letter-spacing: -0.2px; }}
        .brand-tag {{
            font-size: 11px;
            background: #f1f5f9;
            color: #475569;
            padding: 2px 8px;
            border-radius: 6px;
            font-weight: 600;
        }}
        .nav-meta-badge {{
            font-size: 12px;
            color: var(--text-sub);
            display: flex;
            align-items: center;
            gap: 8px;
        }}
        .env-pill {{
            background: #f1f5f9;
            color: #334155;
            padding: 4px 10px;
            border-radius: 9999px;
            font-weight: 600;
            font-size: 11px;
            border: 1px solid var(--border);
        }}

        /* Header Card */
        .header-card {{
            background: var(--card-bg);
            border-radius: 14px;
            padding: 28px 36px;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border);
            border-left: 5px solid {accent_bar};
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }}
        .eyebrow-tag {{
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: var(--primary);
            margin-bottom: 4px;
        }}
        .header-title {{
            font-size: 24px;
            font-weight: 800;
            color: #0f172a;
            letter-spacing: -0.4px;
            margin-bottom: 6px;
        }}
        .header-meta {{
            font-size: 13px;
            color: var(--text-sub);
            display: flex;
            align-items: center;
            gap: 8px;
        }}
        .meta-dot {{ color: #cbd5e1; }}

        /* Status Pills */
        .status-pill {{
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 5px 12px;
            border-radius: 9999px;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.3px;
        }}
        .status-pill-large {{
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 22px;
            border-radius: 9999px;
            font-size: 14px;
            font-weight: 700;
            letter-spacing: 0.4px;
        }}
        .badge-pass {{
            background: #ecfdf5;
            color: #059669;
            border: 1px solid #a7f3d0;
        }}
        .badge-fail {{
            background: #fff1f2;
            color: #e11d48;
            border: 1px solid #fecdd3;
        }}
        .pulsing-dot {{
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background: currentColor;
            display: inline-block;
        }}
        .pulsing-dot-large {{
            width: 9px;
            height: 9px;
            border-radius: 50%;
            background: currentColor;
            display: inline-block;
        }}

        /* Metrics Grid */
        .metrics-grid {{
            display: grid;
            grid-template-columns: repeat(6, 1fr);
            gap: 16px;
            margin-bottom: 36px;
        }}
        .metric-card {{
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 18px 20px;
            box-shadow: var(--card-shadow);
            transition: transform 0.2s, box-shadow 0.2s;
        }}
        .metric-card:hover {{
            transform: translateY(-2px);
            box-shadow: var(--card-shadow-hover);
        }}
        .metric-card-top {{
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }}
        .metric-label {{
            font-size: 11px;
            font-weight: 700;
            color: var(--text-sub);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }}
        .metric-icon {{ color: #94a3b8; }}
        .metric-value {{
            font-size: 26px;
            font-weight: 800;
            color: #0f172a;
            letter-spacing: -0.5px;
            font-variant-numeric: tabular-nums;
        }}
        .metric-value.passed {{ color: #10b981; }}
        .metric-value.failed {{ color: #f43f5e; }}

        /* Tracks Section */
        .track-section {{ margin-bottom: 36px; }}
        .track-header {{
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 16px;
        }}
        .track-badge-icon {{
            width: 28px;
            height: 28px;
            background: #eff6ff;
            color: #2563eb;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
        }}
        .track-title {{
            font-size: 17px;
            font-weight: 700;
            color: #1e293b;
            letter-spacing: -0.2px;
        }}

        /* Module Cards */
        .modules-grid {{
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 20px;
        }}
        .module-card {{
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 24px;
            box-shadow: var(--card-shadow);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: all 0.2s cubic-bezier(0.16, 1, 0.3, 1);
        }}
        .module-card:hover {{
            transform: translateY(-2px);
            border-color: #cbd5e1;
            box-shadow: var(--card-shadow-hover);
        }}
        .card-header {{
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 16px;
        }}
        .module-eyebrow {{
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--text-sub);
            display: block;
            margin-bottom: 2px;
        }}
        .card-title {{
            font-size: 17px;
            font-weight: 700;
            color: #0f172a;
            letter-spacing: -0.3px;
        }}

        /* Progress Bar */
        .progress-container {{ margin-bottom: 20px; }}
        .progress-bar-bg {{
            width: 100%;
            height: 6px;
            background: #f1f5f9;
            border-radius: 9999px;
            overflow: hidden;
        }}
        .progress-bar-fill {{
            height: 100%;
            border-radius: 9999px;
            transition: width 0.4s ease;
        }}

        .card-body {{
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
            padding-bottom: 16px;
            border-bottom: 1px solid #f1f5f9;
        }}
        .metric-big {{
            font-size: 24px;
            font-weight: 800;
            color: #0f172a;
            letter-spacing: -0.4px;
            display: block;
        }}
        .metric-total {{ font-size: 16px; font-weight: 600; color: #94a3b8; }}
        .metric-sub {{ font-size: 12px; color: var(--text-sub); font-weight: 500; }}
        .card-footer {{
            display: flex;
            justify-content: space-between;
            align-items: center;
        }}
        .timestamp {{
            font-size: 12px;
            color: #94a3b8;
            display: flex;
            align-items: center;
        }}
        .btn-detail {{
            background: var(--primary);
            color: #fff;
            border: none;
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
        }}
        .btn-detail:hover {{
            background: var(--primary-hover);
        }}
        .btn-detail:hover .arrow-icon {{
            transform: translateX(3px);
        }}
        .arrow-icon {{ transition: transform 0.2s; }}

        /* Breadcrumb Bar */
        .breadcrumb-bar {{
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }}
        .breadcrumb-btn {{
            background: none;
            border: none;
            color: var(--primary);
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            padding: 4px 8px;
            border-radius: 6px;
            transition: background 0.15s;
        }}
        .breadcrumb-btn:hover {{
            background: #eff6ff;
            text-decoration: none;
        }}
        .breadcrumb-separator {{ color: #cbd5e1; font-size: 14px; }}
        .breadcrumb-current {{ color: var(--text-sub); font-size: 13px; font-weight: 500; }}

        /* Filter Toolbar */
        .filter-toolbar {{
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
        }}
        .filter-tabs {{
            display: flex;
            background: #f1f5f9;
            padding: 4px;
            border-radius: 10px;
            gap: 4px;
        }}
        .tab-btn {{
            background: transparent;
            border: none;
            padding: 6px 14px;
            border-radius: 7px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            color: var(--text-sub);
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.15s;
        }}
        .tab-btn.active {{
            background: #ffffff;
            color: #0f172a;
            box-shadow: 0 1px 2px rgba(0,0,0,0.05);
        }}
        .tab-count {{
            font-size: 11px;
            padding: 1px 6px;
            border-radius: 9999px;
            background: #e2e8f0;
            color: #475569;
        }}
        .tab-btn.active .count-passed {{
            background: #dcfce7;
            color: #15803d;
        }}
        .tab-btn.active .count-failed {{
            background: #ffe4e6;
            color: #be123c;
        }}

        .search-box-wrapper {{
            position: relative;
            display: flex;
            align-items: center;
        }}
        .search-icon {{
            position: absolute;
            left: 12px;
            color: #94a3b8;
            pointer-events: none;
        }}
        .search-input {{
            padding: 8px 14px 8px 36px;
            border: 1px solid var(--border);
            border-radius: 8px;
            width: 340px;
            font-size: 12px;
            background: #fff;
            color: #0f172a;
            outline: none;
            transition: border-color 0.15s, box-shadow 0.15s;
        }}
        .search-input:focus {{
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
        }}

        /* Table Card */
        .table-card {{
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 14px;
            overflow: hidden;
            box-shadow: var(--card-shadow);
        }}
        table {{
            width: 100%;
            border-collapse: collapse;
        }}
        th {{
            background: #f8fafc;
            text-align: left;
            padding: 14px 22px;
            font-size: 11px;
            font-weight: 700;
            color: #475569;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            border-bottom: 1px solid var(--border);
        }}
        td {{
            padding: 16px 22px;
            border-bottom: 1px solid var(--border);
            vertical-align: middle;
        }}
        .col-num {{ font-size: 13px; font-weight: 600; color: #94a3b8; font-variant-numeric: tabular-nums; }}
        .test-path-wrapper {{ display: flex; flex-direction: column; gap: 3px; }}
        .test-primary-name {{ font-size: 14px; font-weight: 600; color: #0f172a; }}
        .test-sub-path {{
            font-family: 'JetBrains Mono', ui-monospace, SFMono-Regular, monospace;
            font-size: 11px;
            color: #64748b;
        }}
        .duration-badge {{
            font-family: 'JetBrains Mono', monospace;
            font-size: 12px;
            font-weight: 600;
            color: #475569;
            background: #f1f5f9;
            padding: 3px 8px;
            border-radius: 6px;
        }}
        .btn-log {{
            background: #f8fafc;
            border: 1px solid var(--border);
            color: #334155;
            padding: 6px 14px;
            border-radius: 7px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            transition: all 0.15s;
        }}
        .btn-log:hover {{
            background: #f1f5f9;
            border-color: #cbd5e1;
            color: #0f172a;
        }}

        /* Terminal Log Window */
        .log-td {{
            padding: 0 22px 20px 22px !important;
            background: #f8fafc;
        }}
        .log-window {{
            background: #090d16;
            border: 1px solid #1e293b;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.2);
        }}
        .log-window-bar {{
            background: #0f172a;
            padding: 10px 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid #1e293b;
        }}
        .mac-dots {{ display: flex; gap: 6px; }}
        .dot {{ width: 10px; height: 10px; border-radius: 50%; display: inline-block; }}
        .dot-red {{ background: #ff5f56; }}
        .dot-yellow {{ background: #ffbd2e; }}
        .dot-green {{ background: #27c93f; }}
        .log-window-title {{
            font-family: 'JetBrains Mono', monospace;
            font-size: 11px;
            font-weight: 600;
            color: #94a3b8;
        }}
        .btn-close-log {{
            background: #1e293b;
            border: none;
            color: #cbd5e1;
            padding: 3px 10px;
            border-radius: 5px;
            font-size: 11px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.15s;
        }}
        .btn-close-log:hover {{ background: #334155; color: #fff; }}
        .log-content {{
            padding: 18px 22px;
            font-family: 'JetBrains Mono', monospace;
            font-size: 12px;
            line-height: 1.65;
            color: #e2e8f0;
            white-space: pre-wrap;
            max-height: 440px;
            overflow-y: auto;
        }}
    </style>
</head>
<body>
    <div class="container">
        <!-- Top Navbar -->
        <div class="top-navbar">
            <div class="brand-box">
                <div class="brand-logo">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M4 17l6-6-6-6"></path><line x1="12" y1="19" x2="20" y2="19"></line></svg>
                </div>
                <span class="brand-name">The Last Deploy — Regression Suite</span>
                <span class="brand-tag">v1.4</span>
            </div>
            <div class="nav-meta-badge">
                <span class="env-pill">LOCAL DEV ENGINE</span>
                <span>Runner: <strong>tld-dev</strong></span>
            </div>
        </div>

        <!-- Master Dashboard View -->
        <div id="master-view">
            <div class="header-card">
                <div>
                    <div class="eyebrow-tag">Master Test Suite</div>
                    <h1 class="header-title">The Last Deploy Master Regression Dashboard</h1>
                    <div class="header-meta">
                        <span>Generated: <strong>{generated_at}</strong></span>
                        <span class="meta-dot">&bull;</span>
                        <span>Environment: <strong>{environment}</strong></span>
                    </div>
                </div>
                <div class="status-pill-large {badge_class if 'badge_class' in locals() else ('badge-pass' if is_overall_passed else 'badge-fail')}">
                    <span class="pulsing-dot-large"></span>
                    {overall_status}
                </div>
            </div>

            <div class="metrics-grid">
                <div class="metric-card">
                    <div class="metric-card-top">
                        <span class="metric-label">Total System Tests</span>
                        <svg class="metric-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                    </div>
                    <div class="metric-value">{total}</div>
                </div>
                <div class="metric-card">
                    <div class="metric-card-top">
                        <span class="metric-label">Total Executed</span>
                        <svg class="metric-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polygon points="10 8 16 12 10 16 10 8"></polygon></svg>
                    </div>
                    <div class="metric-value">{executed}</div>
                </div>
                <div class="metric-card">
                    <div class="metric-card-top">
                        <span class="metric-label">Total Passed</span>
                        <svg class="metric-icon" style="color: #10b981;" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                    </div>
                    <div class="metric-value passed">{passed}</div>
                </div>
                <div class="metric-card">
                    <div class="metric-card-top">
                        <span class="metric-label">Total Failed</span>
                        <svg class="metric-icon" style="color: #f43f5e;" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>
                    </div>
                    <div class="metric-value failed">{failed}</div>
                </div>
                <div class="metric-card">
                    <div class="metric-card-top">
                        <span class="metric-label">Pass Rate</span>
                        <svg class="metric-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="19" y1="5" x2="5" y2="19"></line><circle cx="6.5" cy="6.5" r="2.5"></circle><circle cx="17.5" cy="17.5" r="2.5"></circle></svg>
                    </div>
                    <div class="metric-value">{pass_rate}%</div>
                </div>
                <div class="metric-card">
                    <div class="metric-card-top">
                        <span class="metric-label">Total Duration</span>
                        <svg class="metric-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                    </div>
                    <div class="metric-value">{duration}s</div>
                </div>
            </div>

            {track_sections_html}
        </div>

        <!-- Embedded Track Detail Views -->
        {track_details_html}
    </div>

    <script>
        function showTrackDetail(trackName, modName) {{
            document.getElementById('master-view').style.display = 'none';
            const views = document.querySelectorAll('.track-detail-view');
            views.forEach(v => v.style.display = 'none');
            const target = document.getElementById('track-view-' + trackName);
            if (target) {{
                target.style.display = 'block';
                window.scrollTo(0, 0);
            }}
        }}

        function showMasterDashboard() {{
            const views = document.querySelectorAll('.track-detail-view');
            views.forEach(v => v.style.display = 'none');
            document.getElementById('master-view').style.display = 'block';
            window.scrollTo(0, 0);
        }}

        function toggleLog(uniqueId) {{
            const row = document.getElementById('log-row-' + uniqueId);
            if (row.style.display === 'none') {{
                row.style.display = 'table-row';
            }} else {{
                row.style.display = 'none';
            }}
        }}

        function filterTable(trackName, status) {{
            const container = document.getElementById('track-view-' + trackName);
            const rows = container.querySelectorAll('.test-row');
            const btns = container.querySelectorAll('.tab-btn');
            btns.forEach(b => b.classList.remove('active'));
            event.currentTarget.classList.add('active');

            rows.forEach(r => {{
                const logRow = r.nextElementSibling;
                if (status === 'all' || r.getAttribute('data-status') === status) {{
                    r.style.display = 'table-row';
                }} else {{
                    r.style.display = 'none';
                    if (logRow && logRow.classList.contains('log-row')) {{
                        logRow.style.display = 'none';
                    }}
                }}
            }});
        }}

        function searchTable(trackName) {{
            const container = document.getElementById('track-view-' + trackName);
            const q = document.getElementById('searchInput-' + trackName).value.toLowerCase();
            const rows = container.querySelectorAll('.test-row');
            rows.forEach(r => {{
                const path = r.getAttribute('data-path');
                const logRow = r.nextElementSibling;
                if (path.includes(q)) {{
                    r.style.display = 'table-row';
                }} else {{
                    r.style.display = 'none';
                    if (logRow && logRow.classList.contains('log-row')) {{
                        logRow.style.display = 'none';
                    }}
                }}
            }});
        }}
    </script>
</body>
</html>"""

    master_path = os.path.join(report_dir, "index.html")
    with open(master_path, "w", encoding="utf-8") as f:
        f.write(full_html)


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 report_generator.py <path_to_summary.json>")
        sys.exit(1)

    summary_file = sys.argv[1]
    if not os.path.isfile(summary_file):
        print(f"Error: {summary_file} not found.")
        sys.exit(1)

    with open(summary_file, "r", encoding="utf-8") as f:
        data = json.load(f)

    report_dir = os.path.dirname(os.path.abspath(summary_file))
    generate_single_page_dashboard(data, report_dir)
    print(f"\n Master Regression Dashboard generated at: file://{os.path.join(report_dir, 'index.html')}")


if __name__ == "__main__":
    main()
