# Bop

*Blocks on Pages*. Very simple, very lovely html5 CMS that you can plug into any Rails app. Bop is designed
from the ground up as an engine: for standalone CMS you need `bopulate`, which is an equally minimal
multi-domain hosting package designed for the lazy. Also, doesn't exist yet.

Bop includes modern html5 editing tools, asset-management, content reuse, and drag and drop editing of
page trees.

## Status

Brand new, very alpha, avoid!

## Requirements

A rails 3.2 app with devise and cancan.

## Conventions

Bop works in a very simple way:

* Anything can have a page tree;
* Pages have a template;
* Templates define spaces;
* Spaces have one or more blocks in them;
* Blocks have types, which determine the presentation of their content.

Out of the box, you get three types of block: html, asset or list. It's very easy to add more.

## Templates

At the moment all our page templates are in Liquid. Other templating engines will be supported soon, including
radius. Blocks can be edited in markdown, textile, html or haml. Also, soon, radius.

## Installation

In your gemfile:

    gem "bop"

To migrate:

    rake bop:install:migrations
    rake db:migrate

## Usage

Add this line to one or more of your model classes:

    has_pages

## Customisation (not yet)

To bring Bop javascript, stylesheets and block_type views into your app for customisation:

    rake bop:customise

## Extension (not yet)

Bop will be extensible from your initializers in these constrained ways:

* block types can be added with a simple declaration and the necessary view/edit templates
* markup types can be added for templates or blocks or both

Before long there will also be a simple API for defining new data types or asset types and custom blocks to go 
with them. The interior of Bop is very simple so it's also easy to monkey over if you like that sort of thing.

## Migration from radiant (not yet)

Once radius support is worked in, we will support the automated import of radiant sites. This will bring in
pages, layouts, snippets and assets, but non-core radiant extensions will not be supported. Persuade their 
authors to turn them into bop extensions instead.

## Copyright

Copyright William Ross for Spanner Ltd, 2012
Released under the same terms as ruby and/or rails.





