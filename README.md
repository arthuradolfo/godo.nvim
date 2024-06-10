# godo.nvim

Integrate [godo](https://github.com/gabrielseibel1/godo) with your Neovim.

![](screencast.gif)

## Table of Contents

1. [Requirements](#requirements)
2. [How to Install](#how-to-install)
    1. [Plug](#plug)
    2. [Setup](#setup)
3. [Usage](#usage)
    1. [Vimscript Mapping](#vimscript-mapping)
    2. [Lua Mapping](#lua-mapping)
    3. [Parse Files](#parse-files)
        1. [TODO Patterns](#todo-patterns)
        2. [GODO Patterns](#godo-patterns)

## Requirements

- Works only on Linux flavors
- Requires go installed on system
- To show pretty notifications, `notify.nvim` is required. 
To setup `notify.nvim`, [checkout here](https://github.com/rcarriga/nvim-notify).

## How to install

Use the package manager of your choice.

### Plug

```vim
Plug 'arthuradolfo/godo.nvim'
```

### Setup

In your `.vimrc`, add the following:

```vim
"" godo-nvim
lua << EOF
    require('godo').setup()
EOF
"" END OF godo-nvim
```

Or, add the lua code in your `init.lua`.

## Usage

You can open `godo`'s UI by running:

```vim
:Godo
```

And you can directly call `godo` actions with the following functions:

```vim
:GodoListItems
:GodoGetItem <item-id>
:GodoCreateItem <item-id> <item-description>
:GodoDeleteItem <item-id>
:GodoDoItem <item-id>
:GodoUndoItem <item-id>
:GodoWorkItem <item-id> <time-worked>
:GodoParseFile
```

Also, you can map these functions to keybindings:

### Vimscript Mapping

`.vimrc:`
```vim
nnoremap <leader>gl <cmd>GodoListItems<cr>

nnoremap <leader>gg <cmd>call GodoGetItemFunc(input('Item Id: '))<cr>
func GodoGetItemFunc( item_id )
    execute ':GodoGetItem ' . a:item_id
endfunc

nnoremap <leader>gc <cmd>call GodoCreateItemFunc(input('Item Id: '), input('Description: '))<cr>
func GodoCreateItemFunc( item_id, description )
    execute ':GodoCreateItem ' . a:item_id . ' ' . a:description
endfunc

nnoremap <leader>gr <cmd>call GodoDeleteItemFunc(input('Item Id: '))<cr>
func GodoDeleteItemFunc( item_id )
    execute ':GodoDeleteItem ' . a:item_id
endfunc

nnoremap <leader>gd <cmd>call GodoDoItemFunc(input('Item Id: '))<cr>
func GodoDoItemFunc( item_id )
    execute ':GodoDoItem ' . a:item_id
endfunc

nnoremap <leader>gu <cmd>call GodoUndoItemFunc(input('Item Id: '))<cr>
func GodoUndoItemFunc( item_id )
    execute ':GodoUndoItem ' . a:item_id
endfunc

nnoremap <leader>gw <cmd>call GodoWorkItemFunc(input('Item Id: '), input('Time: '))<cr>
func GodoWorkItemFunc( item_id, time )
    execute ':GodoWorkItem ' . a:item_id . ' ' . a:time
endfunc

nnoremap <leader>gt <cmd>call GodoTagItemsFunc(input('Item Ids (separate with spaces): '), input('Tag: '))<cr>
func GodoTagItemsFunc( item_ids, tag )
    execute ':GodoTagItems ' . a:item_ids . ' ' . a:tag
endfunc

nnoremap <leader>gy <cmd>call GodoUntagItemsFunc(input('Item Ids (separate with spaces): '), input('Tag: '))<cr>
func GodoUntagItemsFunc( item_ids, tag )
    execute ':GodoUntagItems ' . a:item_ids . ' ' . a:tag
endfunc

nnoremap <leader>gp <cmd>GodoParseFile<cr>
```

### Lua Mapping

`init.lua:`
```lua
vim.keymap.set( 'n', '<leader>gl', function()
	vim.cmd.GodoListItems()
end)

vim.keymap.set( 'n', '<leader>gg', function()
	vim.ui.input( { prompt = 'Item id: ' }, function( item_id )
		vim.cmd.GodoGetItem( item_id )
	end)
end)

vim.keymap.set( 'n', '<leader>gc', function()
	vim.ui.input( { prompt = 'Item id: ' }, function( item_id )
        vim.ui.input( { prompt = 'Description: ' }, function (description)
            vim.cmd.GodoCreateItem( item_id, description )
        end)
	end)
end)

vim.keymap.set( 'n', '<leader>gr', function()
	vim.ui.input( { prompt = 'Item id: ' }, function( item_id )
		vim.cmd.GodoDeleteItem( item_id )
	end)
end)

vim.keymap.set( 'n', '<leader>gd', function()
	vim.ui.input( { prompt = 'Item id: ' }, function( item_id )
		vim.cmd.GodoDoItem( item_id )
	end)
end)

vim.keymap.set( 'n', '<leader>gu', function()
	vim.ui.input( { prompt = 'Item id: ' }, function( item_id )
		vim.cmd.GodoUndoItem( item_id )
	end)
end)

vim.keymap.set( 'n', '<leader>gw', function()
	vim.ui.input( { prompt = 'Item id: ' }, function( item_id )
        vim.ui.input( { prompt = 'Time: ' }, function (time)
            vim.cmd.GodoWorkItem( item_id, time )
        end)
	end)
end)

vim.keymap.set( 'n', '<leader>gt', function()
	vim.ui.input( { prompt = 'Item ids (separate with spaces): ' }, function( item_ids )
        vim.ui.input( { prompt = 'Tag: ' }, function (tag)
            vim.cmd.GodoTagItems( item_ids, tag )
        end)
	end)
end)

vim.keymap.set( 'n', '<leader>gy', function()
	vim.ui.input( { prompt = 'Item ids (separate with spaces): ' }, function( item_ids )
        vim.ui.input( { prompt = 'Tag: ' }, function (tag)
            vim.cmd.GodoUntagItems( item_ids, tag )
        end)
	end)
end)

vim.keymap.set( 'n', '<leader>gp', function()
	vim.cmd.GodoParseFile()
end)
```

### Parse files

With `godo.nvim` you can parse files to extract `TODO` and `GODO` items.

#### TODO Patterns

`godo.nvim` recognizes the following TODO patterns:

1. `//TODO some description`
2. `#TODO some description`
3. `'TODO some description`
4. `;TODO some description`
5. `%TODO some description`

After parsing, the id of `TODO` items will be the name of the file without dots,
followed by a incremental number.

#### GODO Patterns

`godo.nvim` also recognizes a different type of `TODO` items, the `GODO` items.
With this syntax, you can define the id and optional tags to your `GODO` item:

`#GODO( myid:mytag1,mytag2 ) some description`

![](parse-screenshot.png)
