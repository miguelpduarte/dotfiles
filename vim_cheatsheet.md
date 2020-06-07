# My vim cheatsheet

Stuff I keep forgetting about vim but should really use more.

**Disclaimer:** I probably won't use the correct vim terms for things here. This is just a place to quickly jot down notes for myself and as such I will use other terms I find more intuitive or that simply are the best way that I find of explaining the behaviour of the command at the time.

## Scrolling the file

Scrolls the file by ensuring that the line that the cursor is at is moved to the relative screen location:

* `zt` - zScroll this line to Top
* `zz` - zScroll this line to zMiddle
* `zb` - zScroll this line to Bottom

## Motions

* `it` - in tag, extremely helpful for messing with HTML (for example `cit`)
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
* `^a` - insert text from register `.`, what was just inserted
* `^x` - enter "insert completion" mode:
    * `^]` - tag (ctags stuff and such)
    * `^p` - previous context
    * `^n` - next context
    * `^f` - filenames
    * `^l` - line
    * `^o` - omni completion

## Spellchecking

(See 'help spell' for more)

* To enable spell checking: `:set spell`
* Go to next bad word: `]s`
* Go to previous bad word: `[s`
* To add the word under cursor as a good word: `zg`
* To add the word under cursor as a bad word: `zw`
* Undo version of both the commands above: `zug`/`zuw`
* Find suggestions for bad words: `z=`
* When in insert mode and the cursor is after a badly spelled word, you can use `^x` to find suggestions

## Folding

Requires `set foldmethod=indent` in `.vimrc`. See https://youtube.com/watch?v=oqYQ7IeDs0E

* _Reveal_ all folds: `zR`
* _Minimize_ all folds: `zM`
* _Reveal_ one level: `zr`
* _Minimize_ one level: `zm`
* _Open_ current fold: `zo`
* _Open_ current fold **recursively**: `zO`
* _Close_ current fold: `zc`
* _Close_ current fold **recursively**: `zC`
* Toggle fold at current position: `za` (I have bound it to <s-tab> as per the video's recommendations and it works pretty well)
* View cursor line ("open just enough folds to make cursor line visible"): `zv`
* Toggle `'foldenable'`: `zi`

## Other / To sort


