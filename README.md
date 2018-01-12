# yearn

Sometimes you just yearn for a package you need to use. You feel guilty about this, but just want to load it with `library()` and have it just work -- and if you don't have the package installed already, simply have the script install it first without having to figure out if it's on CRAN, Bioconductor, or GitHub, etc. If you're in this sort of mood, you probably don't care about case: is it `phangorn` or `Phangorn` or `phangoRn` -- you might even be willing to tolerate a letter or two off (though not by default).

This is sloppy. You should know what packages you need, install them, consider keeping track of versions with [packrat](https://rstudio.github.io/packrat/) or similar. But for a quick and dirty analysis, or when facing a classroom of angry students who are trying to pull in packages for a class exercise, this can be handy ("Download these from CRAN; go to Bioconductor for this; then get this new package that's only on GitHub -- no, it's `install_github()` not `install.github()`, but, yeah, `install.packages()` -- wait, where are you going, class?"). So, to do this,

```
devtools::install_github("bomeara/yearn")
```

And then call a package you want with just

```
library(yearn)
yearn(pkgdown)
```

where `pkgdown` is just an example of a potential package (one used to create the `yearn` package webpage, in fact). Note that currently the package name should be a bare string, not in quotes. Another option, once `yearn` has been installed, is to use the `::` syntax: `yearn::yearn(pkgdown)` without having to do the library call first.

The package goes through a standard procedure when you do this:

1) It tries to load the package with `require()`. If it works, it's done.
2) If not, it tries to find a matching package name (case insensitive) from CRAN and Bioconductor. If you pass a `maxdist` argument to `yearn()`, it will allow up to that many spelling mismatches. By default this is zero. If it finds a match, it installs it, then tries to load it.
3) If this fails, it looks on GitHub. It first looks in the GitHub CRAN mirror -- this includes packages that used to be on CRAN. It installs it there if it finds it.
4) Otherwise, it looks elsewhere on GitHub. If there's one R package that matches, it simply installs it. If there are several, it picks one based on whose repository it's in: an ROpenSci repo is probably more likely to have what you want than a random fork of it a student made for a class assignment. The list of github users that are my guesses can be seen in `?yearn`. If you're using this to teach a class using your software, you might want to add your user name to the list.

This package uses some key functions from the [githubinstall](https://CRAN.R-project.org/package=githubinstall) package on CRAN, written by Koji Makiyama, Atsushi Hayakawa, Shinya Uryu, Hiroaki Yutani, and Nagi Teramo. However, it also incorporates checking CRAN and Bioconductor first, and it does not offer the interactivity of the `githubinstall` package in cases of multiple matches (it also is pickier about spelling mismatches than `githubinstall` by default).

Again, use at your own risk. This package is chatty about potential problems and where it's downloading packages, but it could be that you're loading a package that has the same name of what you want but does something different, someone could have done something malicious with a package they put on GitHub, etc.

Work on this was partially funded by NSF CAREER award 1453424 to Brian O'Meara (the package is useful for the class I teach as part of that award).
