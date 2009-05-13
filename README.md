# Paperclipped Routes

This extension adds to Paperclipped the ability to handle, translate and display GPS routes.

## Requirements

* [GpsBabel](http://www.gpsbabel.org/)
* Paperclipped (currently, the [spanner fork](https://github.com/spanner/paperclipped/tree) is required: I've had to extend Paperclipped so that it's possible to specify additional processors)
* Radiant 0.7.x
* Multimap API key (google maps not hooked up yet)

We use GpsBabel calls in much the same way as Paperclip normally uses Imagemagick. 

## Configuraiton

We need `assets.routes.mm_api_key`, and your [multimap account](https://www.multimap.com/my/signin/) has to be set up for the referring url. 

## Status

We're still in development, but so far:

* accepts most files that GpsBabel understands and creates GPX, TCX (for Garmin Training Center), MMO (for Memory Map) and KML files from them.
* displays basic multimap slidemap of the route.
* map tag javascript is a minimal initialisation of the map viewer. The display code is exemplified in `mm_routes.js` and should be easy to use or customise. Make sure your layout includes that script.

## Notes

* There are no tests yet specific to routes
* In the long term there's no reason why this shouldn't accept all the file formats that GpsBabel does.
* It will be possible to specify other download formats in the usual way.
* I'm working now on the Google Map and Multimap display tags.

## Bugs and comments

In [lighthouse](http://spanner.lighthouseapp.com/projects/26912-radiant-extensions), please, or for little things an email or github message is fine.

## Author and copyright

* Copyright spanner ltd 2009.
* Released under the same terms as Rails and/or Radiant.
* Contact will at spanner.org

