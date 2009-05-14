# Paperclipped GPS

This extension adds to Paperclipped the ability to handle, translate and display GPS routes and tracks of various kinds.

## Requirements

* [GpsBabel](http://www.gpsbabel.org/)
* Paperclipped (currently, the [spanner fork](https://github.com/spanner/paperclipped/tree) is required: we need to be able to specify additional processors)
* Radiant 0.7.x
* Multimap API key (google maps not hooked up yet)

We use GpsBabel calls in much the same way as Paperclip normally uses Imagemagick. 

## Configuraiton

We've only got multimap maps so far so we need `assets.gps.mm_api_key` in config, and your [multimap account](https://www.multimap.com/my/signin/) has to be set up for the referring url. 
Work is underway on a google maps equivalent.

## Status

We're still in development, but so far:

* accepts most files that GpsBabel understands and creates GPX, TCX (for Garmin Training Center), MMO (for Memory Map) and KML files from them.
* displays basic multimap slidemap of the route or track.
* map tag javascript is a minimal initialisation of the map viewer. The multimap code is exemplified in `mm_gps.js` and should be easy to apply as is or to customise.

## Notes

* There are no tests yet specific to GPS files
* In the long term there's no reason why this shouldn't accept all the file formats that GpsBabel can read.
* It will be possible to specify other download formats in the usual way.
* I'm working now on the Google Map and Multimap display tags.

## Bugs and comments

In [lighthouse](http://spanner.lighthouseapp.com/projects/26912-radiant-extensions), please, or for little things an email or github message is fine.

## Author and copyright

* Copyright spanner ltd 2009.
* Released under the same terms as Rails and/or Radiant.
* Contact will at spanner.org

