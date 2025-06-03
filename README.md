# PrettyCss.vim

**PrettyCss** is a lightweight Vim plugin that formats minified or messy CSS code into a clean, readable structure.  
It also includes a **minification** function to compress readable CSS into compact single-line output.  
The plugin works **entirely within Vim** — no external tools or dependencies required.

---

## Features

- Formats CSS into a readable style—works on minified, single-line, or poorly formatted CSS  
- Preserves and places single-line and multi-line `/* ... */` comments on separate lines  
- Fixes indentation and spacing, removing excess or adding where missing  
- Adds missing semicolons where needed  
- Supports nested CSS blocks and rules  
- Simple one-command usage: `:PrettyCss`
- **Minifies readable CSS into compact single-line form using `:MinifyCSS`**  
  - Removes comments, whitespace, and line breaks  
  - Shortens hex colors (e.g., `#ffffff` → `#fff`)  
  - Removes leading zeros in decimals (e.g., `0.3` → `.3`)  
  - Trims leading/trailing whitespace from the file  

---

## Usage

To format the current buffer in Vim or Neovim, run:

```vim
:PrettyCss
````

To minify the CSS code in the buffer, run:

```vim
:MinifyCSS
```

Make sure the buffer’s filetype is set to `css`. The plugin will not run if the filetype is different.

---

## Installation

Install with your favorite Vim plugin manager.

### Example using [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'Xawiu/pretty-css.vim'
```

Then restart Vim and run:

```vim
:PlugInstall
```

---

## Requirements

* Vim 8+ or Neovim
* CSS file opened with correct filetype (`:set filetype=css`)

---

## Example

### Before formatting:

```css
:root{--main-color:#3498db;--spacing:16px;--font-size:calc(14px + 0.2vw)}*
{box-sizing:border-box;  margin:   0;padding:0}body{font-size:var(--font-size);color:var(--main-color);margin:calc(var(--spacing)*2)}header,
footer

{padding:var(--spacing)      }/*** * *Example comment*/@media screen and (max-width:768px      ){body{font-size:calc(12px + 0.5vw)}header,footer{padding:calc(var(--spacing)/2)}/* mobile layout fix */nav ul{flex-direction:column;align-items:flex-start/*example comment 1*//*example comment 2 */}}
```

### After formatting (`:PrettyCss`):

```css
:root {
    --main-color: #3498db;
    --spacing: 16px;
    --font-size: calc(14px + 0.2vw);
}

* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-size: var(--font-size);
    color: var(--main-color);
    margin: calc(var(--spacing)*2);
}

header, footer {
    padding: var(--spacing);
}
/*** * *Example comment*/
@media screen and (max-width: 768px) {
    body {
        font-size: calc(12px + 0.5vw);
    }

    header, footer {
        padding: calc(var(--spacing)/2);
    }
    /* mobile layout fix */
    nav ul {
        flex-direction: column;
        align-items: flex-start;
        /*example comment 1*/
        /*example comment 2 */
    }
}
```

### After minifying (`:MinifyCSS`):

```css
:root{--main-color:#3498db;--spacing:16px;--font-size:calc(14px+.2vw)}*{box-sizing:border-box;margin:0;padding:0}body{font-size:var(--font-size);color:var(--main-color);margin:calc(var(--spacing)*2)}header,footer{padding:var(--spacing)}@media screen and (max-width:768px){body{font-size:calc(12px+.5vw)}header,footer{padding:calc(var(--spacing)/2)}nav ul{flex-direction:column;align-items:flex-start}}
```

---

Contributions and improvements are welcome!

---

## License

Distributed under the [MIT License](LICENSE).

