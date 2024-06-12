---
layout: post
title: 'My .gitconfig file disected'
date: 2024-06-13
author: Kiran Rao
---

This is my .gitconfig. Many are like it, but this one is mine.

It's not long. It's not complicated. But it configures my most important tool. I will be breaking down piece by piece to better understand what I'm configuring and why it's important.

```sh
[user]
	name = Kiran Rao
	email = hi@kiranrao.ca
	signingkey = AAAAABBBBBB

[gpg]
	program = gpg

[commit]
	gpgSign = true

[alias]
	co = checkout
	ci = commit
	st = status
	br = branch
	di = diff
	fp = fetch --prune
	rb = rebase
	hist = log --graph --abbrev-commit --decorate --date=short \
		--format=format:'%C(bold cyan)%h%C(reset) %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)%an%C(reset) %C(bold yellow)%d%C(reset)' \
		--branches --remotes --tags
	git = !exec git
	gti = !exec git
```
