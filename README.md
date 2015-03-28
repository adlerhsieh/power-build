# Power Build (Under Development)

Power Build is a photo album builder which generates a site based on the images in a project. It works as a command line application.

## Requirement

1. Ruby is installed in your Mac or Linux. (Don't use this application in Windows. Nothing has been tested.)
2. The generated site is to be hosted on [GitHub pages](https://pages.github.com/).

## Installation

Run:

```
$gem install power-build
```

or manually write `gem 'power-build'` in the Gemfile before you run `$bundle`.

## Usage

In the root of your project, run:

```
$power init
```

It creates a config file in your project directory. You can adjust the content depending on how you want to build your site, but don't change the file name.

```
$power build
```

You can skip the `build` and just run `power`. This command generates a static site which allows you to host on github pages. Basically it creates a `index.html` and a folder `album` with other pages in it.
