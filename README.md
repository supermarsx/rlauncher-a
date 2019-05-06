# rLauncher

A small multi-language portable launcher for removable drives, written in AutoIt, available only on Windows.

## Quick Start

1. Download the latest release or in turn download the latest source and compile the script locally (require AutoIt installed).
2. Update `launcher.cfg`to your liking.
3. Add categories to `categoria.list` and binary paths to `bins.list`.
4. Add `rlauncher` binary with `launcher.cfg`, `categoria.list` and `bins.list` to your removable or secondary drive.

## Adding applications

To add applications you need to update `categoria.list`and `bins.list` accordingly.

### Adding a new category

1. Open `categoria.list` file.
2. Add a new line with id and chosen category name, csv style.
3. Save file.

Sample:

```
ID,CATEGORY NAME
```

### Adding a new application

To add a new application you'll need to associate it to a category, to add a new category check Adding a new category.

1. Open `bins.list` file.
2. Add a new line following the sample down below, csv style.
3. Save file.

Sample:

```
APPLICATION ID,CATEGORY ID, APPLICATION NAME, BINARY NAME, RELATIVE BINARY PATH, "nada"
```

 Note: Last field `nada` was reserved for future use.

## Mini QA

Q. Does this work with USB thumb drives?

A. Yes, this works with any removable drive as it uses relative paths to binary files.

Q. Does this work on Windows Vista?

A. This application works on any computer with any Windows from XP onwards.

Q. Can I omit a category without updating `bins.list`?

A. Yes but any applications within that category won't be visible on the launcher app.

## License

Distributed under MIT License. See `license.md` for more information.