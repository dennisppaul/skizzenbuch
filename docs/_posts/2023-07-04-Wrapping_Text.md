---
layout: post
title:  "Wrapping Text"
date:   2023-07-04 00:00:00 +0100
featured: Yes
---

![Wrapping_Text](./assets/2023-07-04-Wrapping_Text.png)

a collection of functions that wrap text in 3 simple ways. either for monospaced fonts ( *every character has the same width* ) where text is either wrapped after a certain amount of characters `chop_after_char(String,int)` or after an amount of characters but respecting word integrity ( i.e wraps after next space character ) `‌chop_after_word(String,int)` or for proportional fonts ( *characters have varying width* ) with `chop_after_word_proportional`.

the sketch can be found at [`SketchWrappingText`](https://github.com/dennisppaul/skizzenbuch/tree/master/SketchWrappingText).
