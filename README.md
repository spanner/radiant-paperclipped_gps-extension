# Paperclipped GPS

This extension adds to Paperclipped the ability to handle, translate and display GPS routes and tracks of various kinds.

## Latest

Revised to work with simplified asset type interface. You will need to update paperclipped.

## Requirements

* [GpsBabel](http://www.gpsbabel.org/)
* Paperclipped (currently, the [spanner fork](https://github.com/spanner/paperclipped/tree) is required)
* Radiant 0.8.x
* Multimap API key (google maps not hooked up yet)

We use GpsBabel calls in much the same way as Paperclip normally uses Imagemagick. 

## Configuration

We've only got multimap maps so far so we need `assets.gps.mm_api_key` in config, and your [multimap account](https://www.multimap.com/my/signin/) has to be set up for the referring url.

Work is underway on a google maps equivalent.

## Radius tags

A few useful map tags are defined here:

	r:assets:multimap displays a slidemap (provided you have configured an api key)
	r:assets:googlemap will do the same one day (but not yet)
	r:assets:download takes a format attrbute (which can be 'gpx', 'tcx' or 'kml')

And if you install our library extension you automatically get useful conditional and looping tags for each known asset type, so just as `r:if_images` gets you the page images:

	<r:if_gpses><r:gpses:first><r:assets:multimap /></r:gpses:first></r:if_gpses>

	<r:gpses:each><r:assets:download_link format="gpx" /></r:if_gpses>

Gps pluralizes horribly. Sorry about that.

## Status

We're still in development, but so far:

* accepts most files that GpsBabel understands and creates GPX, TCX (for Garmin Training Center), MMO (for Memory Map) and KML files from them.
* displays basic multimap slidemap of the route or track.
* map tag javascript is a minimal initialisation of the map viewer. The multimap code is exemplified in `mm_gps.js` and should be easy to apply or to customise.

## Warnings

* This extensions adds a hack to `javascript_include_tag` (by overriding `path_to_javascript`) so that javascript addresses beginning with http do not have .js appended to them. This is so we can get the multimap scripts in (which don't have a .js suffix and don't work if you add one). It seems to me like sensible behaviour anyway, but it might conceivably have side effects if you use other third-party scripts and really hate typing '.js'.

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

