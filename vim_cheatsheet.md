# My vim cheatsheet

Stuff I keep forgetting about vim but should really use more.

**Disclaimer:** I probably won't use the correct vim terms for things here. This is just a place to quickly jot down notes for myself and as such I will use other terms I find more intuitive or that simply are the best way that I find of explaining the behaviour of the command at the time.

## Scrolling the file

Scrolls the file by ensuring that the line that the cursor is at is moved to the relative screen location:

* `zt` - zScroll this line to Top
* `zz` - zScroll this line to zMiddle
* `zb` - zScroll this line to Bottom

## Motions

* `it` - in tag, extremly helpful for messing with HTML (for example `cit`)
* `ii`/`ai` - inner indentation/around indentation. Useful for visually selecting code, messing with indentation, etc. (From 'michaeljsmith/vim-indent-object')
* `aI` - (also from vim-indent-object) 

## Cursor placement

Moves the cursor without moving the buffer.

* `H` - Place cursor High
* `M` - Place cursor Medium
* `L` - Place cursor Low

## Indentation

Can be used in visual selections, with movements, etc

* `>` - Increase indentation
* `<` - Decrease indentation

## Commenting

* `gcc` - Toggle comments
* `gcgc` - Remove sequential line comments (something like this)

## Completion

Already used some, but always good to keep in mind (check ["Let Vim Do The Typing" as well](https://www.youtube.com/watch?v=3TX3kV3TICU))

**Note:** These are insert mode shortcuts

It is possible to navigate between matches with the arrow keys or `^n`/`^p`

* `^r` - insert text from a register (extremely useful to replace the typical `"pp` or similar spam)
* `^a` - inser text from register `.`, what was just inserted
* `^x` - enter "insert completion" mode:
    * `^]` - tag (ctags stuff and such)
    * `^p` - previous context
    * `^n` - next context
    * `^f` - filenames
    * `^l` - line
    * `^o` - omnicompletion

## Other / To sort

To enable spell checking: `:set spell`

