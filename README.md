# practical-pig

[![version](https://img.shields.io/gem/v/practical-pig?label=version&style=flat-square)](https://rubygems.org/gems/practical-pig)
[![status](https://img.shields.io/travis/thearchitector/practical-pig?style=flat-square)](https://travis-ci.org/github/thearchitector/practical-pig)
[![downloads](https://img.shields.io/gem/dt/practical-pig?style=flat-square)](https://rubygems.org/gems/practical-pig)
[![license](https://img.shields.io/badge/license-MIT-green?style=flat-square)](./LICENSE)

Practical Pig is an opinionated Ruby on Rails template that makes use of webpacker-pnpm, RuboCop, and Prettier to provide a simple yet robust foundation for any web application.

## Features

- Opinionated so you don't have to deal with the nitty-gritty
- Provides production-ready application templates
- Agnostic of underlying Rails version

## Installation and Usage

Assuming you have `pnpm` installed, simply download the gem to your system and then create a new repository as you would using `rails`.

```sh
$ gem install practical-pig
$ pig new APP_PATH
```

To view the help dialog, you may run `pig help new`, which will yield the following output:

```plaintext
Usage:
  pig new APP_PATH

Options:
  -q, [--quiet], [--no-quiet]  # Suppress status output

Description:
  `pig new` will generate a new Ruby on Rails application and modify it to adhere
  to Practical Pig's application design guidelines.

  The APP_PATH you provide will be used as the path of the application during
  creation, with its name being the basename (last part of the path). In every
  case, the new application will be generated relative to the current working
  directory (where you execute this command).

  By design, your application name must start and end with an alphanumeric
  character.

  This command makes use of `rails new` under the hood but does not accept any
  generator options.
```

## License

MIT License

Copyright (c) 2020 Elias Gabriel

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the conditions outlined in [LICENSE](./LICENSE).
