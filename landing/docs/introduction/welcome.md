---
title: "Welcome to The Last Deploy"
description: "An open-source DevOps learning platform where you learn by doing — not watching."
section: "Introduction"
---

The Last Deploy is an open-source platform for learning DevOps by solving real-world infrastructure labs.

Instead of watching videos, you deploy. Instead of memorizing commands, you break production. Instead of tutorials, you solve incidents.

## What is TLD?

TLD gives you deliberately broken systems — misconfigured nginx servers, crashed containers, corrupted git histories, broken CI pipelines — and asks you to fix them. Every lab runs entirely on your own machine using Docker. No cloud account needed.

<Callout variant="info" title="Open source and free" text="TLD is Apache 2.0 licensed. Every lab, every validator, every line of code is public. No paywalls, no subscriptions, no vendor lock-in." />

## How it works

<Steps>
  <Step title="Install the CLI" code="curl -fsSL https://install.thelastdeploy.com | sh">One command to install the tld agent on your machine.</Step>
  <Step title="Start a lab" code="tld lab start dkr-fix-stopped-container">Pick a track and spin up your first broken environment.</Step>
  <Step title="Fix the system">Read the scenario, investigate, and repair the broken infrastructure using real tools in a real terminal.</Step>
  <Step title="Validate your solution" code="tld check">Run the automated checker. It tells you exactly what passed and what didn't.</Step>
  <Step title="Earn XP and progress">Track your progress across labs and unlock harder challenges.</Step>
</Steps>

## No cloud fees. Ever.

Every TLD lab runs inside Docker containers on your own machine. There are no AWS credits to burn, no Kubernetes cluster to provision, and no surprise bills. If you have Docker installed, you have everything you need.