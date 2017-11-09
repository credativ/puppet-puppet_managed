# puppet_managed

#### Table of Contents

1. [Overview](#overview)
1. [Module description](#module-description)
1. [Setup - The basics of getting started with puppet_managed](#setup)
    * [What puppet_managed affects](#what-puppet_managed-affects)
    * [Beginning with puppet_managed](#beginning-with-puppet_managed)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Overview

Adds a new custom parser function that makes adding a managed by puppet header less repetitive.

## Module description

This modules provides a single custom parser function, called
puppet_managed. It can be called from templates to automatically generate a comment header telling the user that this file is managed by puppet.


## Setup

Since puppet_managed is a custom parser function it requires
pluginsync and is available once installed.

### Usage

To add a basic header "# MANAGED BY PUPPET" add the following to your <template:

```puppet
<%= scope.function_puppet_managed([]) %>
```

Not that helpful, yet, is it? Let's make it more verbose:

```puppet
<%= scope.function_puppet_managed([ {'filename' => __FILE__, 'verbose' => true }]) %>
```

This creates a multi-line comment, adding the following informations:

* the name of the class where this template is being instanciated
* the path to the the template file (on the puppetmaster)


### Changing Comment style

The default comment style is prefixing each line of the comment with a hash sign, which should already be enough for many cases.

Apart from that, one can choose from some preconfigured comment styles,
by adding the parameter comment_style with one of the values below:

| Name    | Description                                                                              |
|---------|------------------------------------------------------------------------------------------|
| c-block | Add a c-style block comment, each line prefixed with a an asterisk, beautifully aligned. |
| sql     | Prefix each line with two dashes, like in SQL scripts.                                   |
| percent | Prefix each line with a percent sign.                                                    |
| vim     | Prefix each line with quotes (") as used in vim configuration files.                     |
| xml     | HTML/XML-like block comment                                                              |


### Using a custom prefix

If the existing styles are not enough (or if you want to save some chars ;) you can also specify a prefix

```puppet
<%= scope.function_puppet_managed([ {'prefix' => '!!', verbose' => true }]) %>
```


## Development

I happily accept bug reports and pull requests via github.

## Contributors

This module is written and being maintained by

    Patrick Schoenfeld <patrick.schoenfeld@credativ.de>.

