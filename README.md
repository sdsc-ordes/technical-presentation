<img src="docs/logo.svg" style="margin-right: 10pt;width:100pt" align="right">
<h1>Technical Presentation</h1>

<br>
Make technical presentations in Markdown/HTML etc.

This uses [`revealjs`](https://github.com/hakimel/reveal.js) with some
modifications to package to PDF and standalone HTML format. Also it includes a
company `scss` file for design modifications.

- **See the
  [demo presentation here](https://gabyx.github.io/Technical-Presentation)**.
- **See some other
  [C++ presentation here](https://gabyx.github.io/tech-pr-cpp-value-catergories)**
  [src](https://github.com/gabyx/tech-pr-cpp-value-catergories).

Authors:

- [Gabriel Nützi](https://github.com/gabyx) and
- [Simon Spörri](https://github.com/simonspoerri).

Current [`revealjs`](https://github.com/hakimel/reveal.js) version: `4.6.1`

## Requirements

### Using [`nix`](https://nixos.org)

You can enter a development shell with

```shell
nix develop ./nix#default
```

where all requirements are installed to start working on your first
presentation.

### DevContainer

There is a minimal `.devcontainer` which lets you

### Manual

You need the following tools:

- `bash`
- `just`
- `rsync`
- `inotifywait`
- `npm`
- `yarn`

## Usage

1. **`just init`** -> Init the `build` folder with the pinned
   [`reveal.js`](.gitmodules) source and inject some [changed files](src/mixing)
   (styles, fonts, etc.) and install dependencies inside the build folder.

2. **`just watch`** -> Watch the files in [`src`](src/) and synchronize changes
   to the `build` folder. This is needed to continuously update your changes
   source files and make the browser reload the page.

3. **`just present`** -> Serve the presentation in the browser and continuously
   reload the page.

4. **`just package`** -> Export the presentation as HTML and PDF inside a `.zip`
   file to the [`publish`](publish) folder.

## Make a Presentation

- Write your presentation in Markdown in
  [`src/presentations`](src/presentations). All images and other assets needed
  by the presentation should go into the respective `assets` directory (e.g.
  [`presentation-1/assets`](/src/presentations/presentation-1/assets))

## Resources

Check the following resources with additional slide materials:

- [Documentation](https://revealjs.com/)
- [Markdown from a C++ presentation](https://github.com/gabyx/tech-pr-cpp-value-catergories/blob/main/files/cpp-meeting/Vortrag.md)
  [View](https://gabyx.github.io/tech-pr-cpp-value-catergories)

## Modifications

- Edit the design in [`company.scss`](css/theme/source/company.scss).

- Company Logo: Edit the file
  [`company-logo.svg`](css/theme/source/files/company-logo.svg).

  - Replace embedded image in [`company.scss`](css/theme/source/company.scss)
    with

  ```shell
  just bake-logo
  ```
