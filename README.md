# My Dotfiles

I used to keep separate repos for my `vim` and `emacs.d` directories. Now I'm
following the lead of several prominent Githubbers, and keep everything in
a single nicely structured repo.

Use the `Makefile` to create symlinks from the `dotfile` folder to the file and
folder locations in the user home directory. N.B. this will overwrite any files
or folders already there!

The folders for each main function here are kept as independent as possible,
because of that, they all contain separate `.gitignore` files.
