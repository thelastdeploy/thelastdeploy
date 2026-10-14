#!/usr/bin/env python3
"""
Audit all lab.yaml and module.yaml files across challenges/
"""
import glob
import os
import re
import sys
from collections import defaultdict

CHALLENGES_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "challenges"))

AUTO_PROFILE_MAP = [
    ("nginx-", "tld-nginx"),
    ("docker-", "tld-docker"),
    ("container-", "tld-docker"),
    ("k8s-", "tld-k8s"),
    ("terraform-", "tld-terraform"),
    ("git-", "tld-git"),
]

def auto_profile(module_id: str) -> str:
    for prefix, prof in AUTO_PROFILE_MAP:
        if module_id.startswith(prefix):
            return prof
    return "tld-linux"

def audit():
    lab_files = sorted(glob.glob(os.path.join(CHALLENGES_DIR, "**/lab.yaml"), recursive=True))
    module_files = sorted(glob.glob(os.path.join(CHALLENGES_DIR, "*/module.yaml")))

    print(f"Total modules found: {len(module_files)}")
    print(f"Total labs found: {len(lab_files)}")
    print("-" * 60)

    stats = defaultdict(int)
    apt_in_seeds = []
    systemctl_in_seeds = []
    docker_in_seeds = []

    for lab_path in lab_files:
        rel = os.path.relpath(lab_path, CHALLENGES_DIR)
        parts = rel.split(os.sep)
        module_id = parts[0]
        lab_id = parts[-2]

        with open(lab_path, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()

        prof = auto_profile(module_id)
        stats[prof] += 1

        if re.search(r"\bapt-get\s+install\b|\bapt\s+install\b", content):
            apt_in_seeds.append((module_id, lab_id, lab_path))

        if re.search(r"\bsystemctl\b|\bservice\b", content):
            systemctl_in_seeds.append((module_id, lab_id, lab_path))

        if re.search(r"\bdocker\s+|\bdocker-compose\b", content):
            docker_in_seeds.append((module_id, lab_id, lab_path))

    print("\n📊 Labs by Track Profile:")
    for prof, count in sorted(stats.items(), key=lambda x: -x[1]):
        print(f"  {prof:15s}: {count:3d} labs")

    print(f"\n📦 Labs with apt-get/apt install in lab.yaml ({len(apt_in_seeds)}):")
    for mod, lab, path in apt_in_seeds[:15]:
        print(f"  - [{mod}] {lab}")
    if len(apt_in_seeds) > 15:
        print(f"    ... and {len(apt_in_seeds) - 15} more")

    print(f"\n⚙️  Labs using systemctl/service ({len(systemctl_in_seeds)}):")
    for mod, lab, path in systemctl_in_seeds[:15]:
        print(f"  - [{mod}] {lab}")
    if len(systemctl_in_seeds) > 15:
        print(f"    ... and {len(systemctl_in_seeds) - 15} more")

    print(f"\n🐳 Labs using Docker/Compose in seed ({len(docker_in_seeds)}):")
    for mod, lab, path in docker_in_seeds[:15]:
        print(f"  - [{mod}] {lab}")
    if len(docker_in_seeds) > 15:
        print(f"    ... and {len(docker_in_seeds) - 15} more")

if __name__ == "__main__":
    audit()
