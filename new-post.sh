#!/bin/bash

# Quick Jekyll post creator
read -p "Post title: " title
slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')
filename="_posts/$(date +%Y-%m-%d)-$slug.md"

cat > "$filename" << EOF
---
layout: post
title: $title
tag: personal
---

## Introduction

Write your post here...
EOF

echo "Created: $filename"
open "$filename"  # Opens in default editor
