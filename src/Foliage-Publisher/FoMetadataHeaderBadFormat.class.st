"
Error raised when a malformed Foliage metadata header is found!

A valid metadata header must contains:
- one or many lines with the format: `key: value`
- followed by a blank line acting as a separator for the header
example:
```
title: my title
author: my name
date: today

```

We prefer to use the yaml metadata block syntax that is also supported:
```
---
title: my title
author: my name
date: today
---
```
"
Class {
	#name : #FoMetadataHeaderBadFormat,
	#superclass : #Error,
	#category : #'Foliage-Publisher'
}
