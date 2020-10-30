---
layout: post
title: 'Setup a Development Workspace with a Sparse Bundle'
date: 2020-10-30
author: Kiran Rao
---

A sparse bundle is a macOS file that contents and structure of a full file system. When mounted, macOS will create a logical volume allowing you to access files the same way you would a USB stick or SSD partition. There are a number of advantages to having your development environment setup within a sparse bundle:

- Keeps projects in a single, self-contained file
- If you work for multiple clients, each one can have their separate disk image completely isolated
- Can get your development environment closer to production

## Create a Sparse Bundle

```sh
hdiutil create \
  -fs 'Case-sensitive APFS' \
  -size 100g \
  -volname "workspace" \
  ~/workspace.sparsebundle
```

Let's break this down:

- `hdiutil create`: Creates the a bundle using the hdiutil
- `-fs 'Case-sensitive APFS'`: -fs selects the file system type. A key difference between macOS and Linux is that Linux is case sensitive. Having a case sensitive workspace has allowed me to catch extremely subtle errors (such as `import 'File'` vs `import 'file'`).
- `-size 100g`: Set the maximum size to 100gb. Don't worry, it won't allocate all 100gb until you use it.
- `-volname "workspace"`: Sets the volume name to workspace
- `~/workspace.sparseimage`: Output file path

Double click your newly created file and voila! You now have a mounted disk image.
