# OrientDB Documentation

Welcome to **OrientDB** - the first Multi-Model Open Source NoSQL DBMS that brings together the power of graphs and the flexibility of documents into one scalable high-performance operational database.

![image](http://www.orientdb.com/images/orientdb_logo_mid.png)

## Documentation Builds

Building the OrientDB Documentation website and PDF requires that you install Git, Node.js and GitBook on your system.  While you can install Git and Node.js through your package manager, GitBook requires `npm`, the Node.js package manager tool.  Be sure that you install GitBook in global mode:

```sh
$ sudo npm install gitbook-cli -g
```

The documentation builds are managed through `make`.  The packaged `Makefile` has the following build targets:

- `create`: Builds the documentation website at `./deploy/latest`.
- `pdf`: Builds the documentation PDF at `./deploy/pdf`.
- `install`: Installs GitBook plugins needed for build.
- `clean`: Removes content from `./deploy/latest`.
- `pull`: Pulls down latest documentation source files from GitHub.
- `all`: Runs website and PDF builds.


## Rules and Code Conventions

### Links

In order for GitBook to properly format and process links, (and to ensure that it throws the appropriate warnings in the event of errors), you MUST use the following format:

- Internal Links to Docs Page: `[Title](filename.md)`
- Internal Link to Chapter: `[Title](filename.md#chapter_heading)`
- External Links: `[Title](http://example.com)`

### Warning Boxes

GitBook does not include admonition boxes by default.  Use the following format to create them:

```markdown
| | |
|----|-----|
|![](images/warning.png)|YOUR MESSAGE|
```

### Variables

Variables can be defined into the "variables" tag in the documentation .json files (book.json and book-pdf.json), e.g:

```
"variables": {
    "variable_name": "variable_value"
  },
```

Then you can refer to them inside any documentation page, e.g. {{ book.variable_name }}


#### Example

To make sure the OrientDB download link points to the latest version, use inside your page the following code:

```
<pre><code class="lang-sh">$ wget {{book.CE_link}} -O {{book.CE_name}}-{{book.lastGA}}.tar.gz</code></pre>	
```

### Include Files

To include a file

```
{% include "./include-file-2.md" %}
```

### Subsections

After the 3.0 refactor, and to avoid huge confusion in the reader, it is important to avoid situations where

Section1.md has subsection1, 2, 3 (within the file) and SUMMARY.md shows subsection4, 5, 6 as subsections of Section1.md

The above is really confusing. Rather:

- Call Section1.md README.md. Ideally put it in to a specific subfolder
- Add a very general description (a few sentences) in README.md  (do not add subsections!)
- Create 1 page for any of the 6 subsections 1 to 6
- Link all the 6 subsections to SUMMARY.md (under Section1.md)
- [Example 1](gettingstarted/demodb/), [Example 2](console/)  