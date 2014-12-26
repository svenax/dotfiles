# My Emacs Configuration

I have started out trying to use Emacs many, many times over the years. I was
even using it exclusively for something like six months about seven years ago.
I never really stuck with it, though, mostly for it being so hard to configure
*just right*.

This time around I started with **GNU Emacs 24.3**, some handy tips from the
Internet, and the very helpful ELPA package manager. That was almost enough to
convince me. **Enter Aquamacs 3p1** and more Internet goodies. Now, this looks
really promising! The defaults are reasonable, several of the annoyances of GNU
Emacs are gone (recentering the display on scroll, wtf?) It did not take me
more than an hour or so to tet the initial configuration done.

I'm starting small this time. Not too much messing around.

## Paths

I use the standard `~/.emacs.d` location for ny files, instead of Aquamacs
default location. This is because I started with GNU Emacs, but also because
I don't like to have user-editable stuff in the Library folder.

All path setting is done in `load-path.el`. It starts with forcing Aquamacs to
use the my own **user-emacs-directory** and then it tries to be smart about
what other folders to include.

## Config

Even though I may eventually split configuration into several files, it really
is a good idea to keep things together in one place.

* The [Emacs rocks][er] screencasts by Magnar Sveen was what really
  got me started this time. His enthusiasm is quite contagious. Watch
  and see for yourself!
* [Use-package][up] by John Wiegley is fantastic for keeping the
  init.el file neat and tidy. It is supposed to be very efficient too,
  using delayed loading for most things.
* [Dot-emacs][de] by same provided some inspiration, though his
  init.el file is huge!

## Packages

I am still trying lots of different packages. All (almost) installed from ELPA
or MELPA. The packages themselves are not checked in here. There will be
sufficient information in the `* Messages *` buffer to easily reinstall what's
required if so needed.

[up]: https://github.com/jwiegley/use-package
[de]: https://github.com/jwiegley/dot-emacs
[er]: http://emacsrocks.com

