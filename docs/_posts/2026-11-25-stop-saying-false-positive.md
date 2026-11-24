---
layout: post
title: 'Stop saying false positive/negative'
subtitle: "Stop saying false positive/negative. Describe what's happening instead"
date: 2026-11-25
author: Kiran Rao
---

Stop saying false positive/negative. It's confusing and hard to understand. Instead, **replace positive/negative with a description of the event**. For example:

- _What's the GPS receiver false positive rate?_ → _What's the GPS receiver false lock rate?_
- _It's unacceptable for the fire alarm to have false negatives_ → _It's unacceptable for the fire alarm to miss a fire_
- _We rolled out a new DKIM lookup for our spam detector. Unfortunately, it has a lot of false positives_ → _Unfortunately, it has a lot of false rejections_

## Why

**It can be ambiguous**. "GPS receiver false positive" could mean a lot of different things. A "false lock" is far more precise.

**It's prone to double negatives**, which are hard to understand. "fire alarm to have false negatives" requires me to figure out that "positive" means detecting and "negative" means not detecting a fire. Then false negative means not detecting a fire that exists. "miss a fire" is much clearer.

**It can be misinterpreted**. A false positives "DKIM lookup for our spam detector" could be referring to the lookup or spam detection. A positive lookup and a positive spam detection mean opposite things. "false rejections" is unambiguous for both DKIM and spam detection.

## Type I and Type II Error

Using Type I and Type II Error is even worse. No one remembers which is which without looking it up. If you do, the person you're communicating with probably doesn't remember. If everyone remembers, it can still be unclear for all the reasons above. Let's all stop using them.
