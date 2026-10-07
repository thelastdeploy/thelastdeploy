#!/usr/bin/env python3
"""
sync_readme_tracks.py
Dynamically scans challenges/*/module.yaml in the repository,
groups challenges by topic/track, calculates module counts,
and updates the Track Cards grid section in README.md.
"""

import os
import re
import sys
import glob
import yaml

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
README_PATH = os.path.join(REPO_ROOT, "README.md")
CHALLENGES_DIR = os.path.join(REPO_ROOT, "challenges")

TRACK_METADATA = {
    "linux": {
        "title": "Linux Administration",
        "icon": "🐧",
        "description": "System fundamentals, process management, systemd, storage, LVM, networking & incident response.",
        "status": "Available",
    },
    "docker": {
        "title": "Docker & Containers",
        "icon": "🐳",
        "description": "Container runtime isolation, image optimization, multi-stage builds, networking, storage & Compose.",
        "status": "Available",
    },
    "kubernetes": {
        "title": "Kubernetes & Cloud Native",
        "icon": "☸️",
        "description": "Pod debugging, service routing, ConfigMaps, volume storage, workloads & cluster troubleshooting.",
        "status": "Available",
    },
    "nginx": {
        "title": "Nginx & Web Servers",
        "icon": "🌐",
        "description": "Reverse proxying, load balancing, TLS configuration, rate limiting, location routing & security.",
        "status": "Available",
    },
    "terraform": {
        "title": "Terraform & IaC",
        "icon": "🏗️",
        "description": "HCL syntax, state management, module architecture, variable scoping & infrastructure drift.",
        "status": "Available",
    },
    "git": {
        "title": "Git & Version Control",
        "icon": "🔀",
        "description": "Advanced workflows, rebase conflicts, detached HEADs, reflog recovery & history rewrites.",
        "status": "Available",
    },
    "cicd": {
        "title": "CI/CD Pipelines",
        "icon": "🔄",
        "description": "Automated build pipelines, secret management, test integration & artifact deployment.",
        "status": "Coming Soon",
    },
    "observability": {
        "title": "Observability & Monitoring",
        "icon": "📊",
        "description": "Metrics collection, Prometheus queries, Grafana dashboards, log aggregation & alerting.",
        "status": "Coming Soon",
    },
}

TOPIC_ALIASES = {
    "k8s": "kubernetes",
    "bash": "linux",
    "system": "linux",
    "shell": "linux",
}

def scan_challenges():
    topic_counts = {}
    pattern = os.path.join(CHALLENGES_DIR, "*", "module.yaml")
    
    for filepath in glob.glob(pattern):
        try:
            with open(filepath, "r", encoding="utf-8") as f:
                data = yaml.safe_load(f)
                if not data:
                    continue
                topic = data.get("topic", "").lower()
                if not topic:
                    dirname = os.path.basename(os.path.dirname(filepath))
                    topic = dirname.split("-")[0]
                
                topic = TOPIC_ALIASES.get(topic, topic)
                topic_counts[topic] = topic_counts.get(topic, 0) + 1
        except Exception as e:
            print(f"Warning: Failed to parse {filepath}: {e}", file=sys.stderr)
            
    return topic_counts

def generate_cards_html(topic_counts):
    all_topics = list(TRACK_METADATA.keys())
    for t in topic_counts.keys():
        if t not in all_topics:
            all_topics.append(t)

    card_items = []
    for topic in all_topics:
        meta = TRACK_METADATA.get(topic, {
            "title": topic.replace("-", " ").title(),
            "icon": "📦",
            "description": f"Challenge modules covering {topic}.",
            "status": "Available" if topic_counts.get(topic, 0) > 0 else "Coming Soon"
        })
        
        count = topic_counts.get(topic, 0)
        if count > 0:
            count_str = f"<b>{count}</b> modules"
            status_badge = '<a href="http://localhost:9002/docs"><img src="https://img.shields.io/badge/Status-Available-brightgreen?style=flat-square" alt="Available" /></a>'
        else:
            count_str = "<i>Upcoming</i>"
            status_badge = '<img src="https://img.shields.io/badge/Status-Coming%20Soon-orange?style=flat-square" alt="Coming Soon" />'
            
        card_html = f"""<td width="50%" valign="top">
  <h4>{meta['icon']} {meta['title']}</h4>
  <p>{meta['description']}</p>
  <p><sub>📦 Content: {count_str} &nbsp;|&nbsp; {status_badge}</sub></p>
</td>"""
        card_items.append(card_html)
        
    rows_html = []
    for i in range(0, len(card_items), 2):
        row = "<tr>\n" + card_items[i] + "\n"
        if i + 1 < len(card_items):
            row += card_items[i+1] + "\n"
        else:
            row += '<td width="50%" valign="top"></td>\n'
        row += "</tr>"
        rows_html.append(row)
        
    table_html = "<table width=\"100%\">\n" + "\n".join(rows_html) + "\n</table>"
    return table_html

def update_readme(new_html):
    with open(README_PATH, "r", encoding="utf-8") as f:
        content = f.read()
        
    start_tag = "<!-- TRACKS_START -->"
    end_tag = "<!-- TRACKS_END -->"
    
    pattern = re.compile(rf"{re.escape(start_tag)}.*?{re.escape(end_tag)}", re.DOTALL)
    replacement = f"{start_tag}\n{new_html}\n{end_tag}"
    
    if not pattern.search(content):
        print(f"Error: {start_tag} and {end_tag} markers not found in {README_PATH}", file=sys.stderr)
        sys.exit(1)
        
    updated_content = pattern.sub(replacement, content)
    
    with open(README_PATH, "w", encoding="utf-8") as f:
        f.write(updated_content)
        
    print(f"Successfully updated track cards in {README_PATH}")

def main():
    counts = scan_challenges()
    print(f"Scanned challenge modules by topic: {counts}")
    html = generate_cards_html(counts)
    update_readme(html)

if __name__ == "__main__":
    main()
