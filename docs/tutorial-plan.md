# Neovim Configuration Tutorial/Slides Plan

## Overview

Create a reveal.js presentation to onboard engineers to the neovim development environment. The presentation will cover all installed plugins with their use cases, primary features, and workflows.

### Target Audience
- Engineers already familiar with vim basics (hjkl, modes, basic editing)
- No need for vim fundamentals - focus on plugins and this specific config

### Format
- **Comprehensive**: 30-40 slides with detailed coverage
- **Hands-on exercises**: Practice tasks between major sections
- **Equal coverage**: All plugins covered with similar depth

---

## Presentation Structure

### 1. Introduction (2-3 slides)
- **Welcome & Goals**: What this config provides (LSP, linting, fuzzy finding, Git integration)
- **Quick Start**: `make install` and basic setup
- **Key Philosophy**: vim-plug + coc.nvim (LSP) + ALE (linting) + Lua plugins (modern UI)

### 2. Essential Concepts (2 slides)
- **Leader Key**: `,` (comma) - all custom mappings start here
- **LocalLeader**: `,,` - language-specific commands
- **which-key.nvim**: Press `,` and wait to discover all mappings

**Exercise 1**: Open nvim, press `,` and wait. Explore the popup. Try `,f` to find a file.

---

## Plugin Sections

### 3. Core LSP & Completion: coc.nvim (4-5 slides)
**Primary Use Case**: Code intelligence - completion, go-to-definition, refactoring

**Slide 3a - What is coc.nvim?**
- LSP client providing IDE-like features
- Extensions: coc-tsserver, coc-go, coc-rust-analyzer, coc-solargraph, coc-json

**Slide 3b - Primary Features (Must Know)**
| Key | Action |
|-----|--------|
| `Tab` / `Shift-Tab` | Navigate completion |
| `Enter` | Confirm completion |
| `K` | Hover documentation |
| `,gd` | Go to definition |
| `,gr` | Find references |
| `,rn` | Rename symbol |

**Slide 3c - Code Actions & Diagnostics**
| Key | Action |
|-----|--------|
| `,ca` | Code actions (auto-import, quick fixes) |
| `,qf` | Quick fix current issue |
| `[g` / `]g` | Jump to prev/next diagnostic |

**Slide 3d - Advanced Features (Appendix)**
- `,gt` - Go to type definition
- `,gi` - Go to implementation
- `,cf` - Format code
- `,re` - Refactor
- `,co` - Show outline (CocList)
- `,cs` - Search symbols
- Text objects: `if`/`af` (function), `ic`/`ac` (class)

**Exercise 2**: Open a code file. Use `,gd` to jump to a definition. Use `Ctrl-o` to jump back. Try `K` to see documentation. Use `,gr` to find all references.

---

### 4. Linting & Formatting: ALE (3 slides)
**Primary Use Case**: Automatic linting on save, code formatting

**Slide 4a - What is ALE?**
- Asynchronous Lint Engine
- Runs linters in background without blocking
- Auto-fixes on save (prettier, gofmt, rustfmt, rubocop)

**Slide 4b - Primary Features**
| Key | Action |
|-----|--------|
| `[e` / `]e` | Jump to prev/next lint error |
| `,d` | Show error detail |
| (automatic) | Fix on save |

**Slide 4c - Language-Specific Linters (Appendix)**
| Language | Linter | Fixer |
|----------|--------|-------|
| Go | golangci-lint | goimports, gofmt |
| Ruby | rubocop | rubocop |
| JS/TS | eslint | prettier, eslint |
| Rust | cargo/clippy | rustfmt |

**Exercise 3**: Open a file with linting issues (or introduce one). Use `]e` to jump to the error. Use `,d` to see details. Save the file to see auto-fix in action.

---

### 5. Fuzzy Finding: fzf.vim (3-4 slides)
**Primary Use Case**: Fast file/content search across entire project

**Slide 5a - What is fzf?**
- Lightning-fast fuzzy finder
- Uses ripgrep for content search
- Preview window on the right

**Slide 5b - Primary Features (Daily Use)**
| Key | Action | When to Use |
|-----|--------|-------------|
| `,f` | Find files | Open any file by name |
| `,g` | Grep (ripgrep) | Search for text in codebase |
| `,b` | List buffers | Switch between open files |
| `,*` | Grep word under cursor | Find usages of current word |

**Slide 5c - Git-Aware Search**
| Key | Action |
|-----|--------|
| `,gf` | Git files (respects .gitignore) |
| `,gs` | Git status files (modified files) |

**Slide 5d - Other Features (Appendix)**
- `,l` - Search lines in current buffer
- `,h` - File history (recently opened)
- `,c` - Commands
- `,:` - Command history
- `,/` - Search history
- `Ctrl-/` - Toggle preview window

**Exercise 4**: Use `,f` to find a file by partial name. Use `,g` to search for a function name across the codebase. Use `,*` with cursor on a variable to find all usages.

---

### 6. File Explorer: nvim-tree (2 slides)
**Primary Use Case**: Visual file navigation and project structure

**Slide 6a - Primary Features**
| Key | Action |
|-----|--------|
| `,E` | Toggle nvim-tree sidebar |
| `,ef` | Find current file in tree |

**Slide 6b - Tree Navigation (Appendix)**
- `Enter` - Open file/expand folder
- `a` - Create new file
- `d` - Delete
- `r` - Rename
- `c` / `p` - Copy / Paste
- `I` - Toggle hidden files
- `?` - Help

**Exercise 5**: Use `,E` to open the file tree. Navigate with `j`/`k`. Create a new file with `a`. Delete it with `d`. Use `,ef` to locate the current file in the tree.

---

### 7. Git Integration (3 slides)
**Primary Use Case**: View changes, blame, stage hunks

**Slide 7a - gitsigns.nvim (In-Editor Git)**
| Key | Action |
|-----|--------|
| `]c` / `[c` | Jump to next/prev hunk |
| `,hp` | Preview hunk (see diff) |
| `,hb` | Blame current line |
- Sign column shows: `│` (add/change), `_` (delete)

**Slide 7b - vim-fugitive (Git Commands)**
- `:Git` / `:G` - Open Git status
- `:Git blame` - Full file blame
- `:Git diff` - Diff view
- `:Gwrite` - Stage current file
- `:Gread` - Checkout current file

**Slide 7c - vim-rhubarb (GitHub Integration)**
- `:GBrowse` - Open file on GitHub
- Works with visual selection for line ranges

**Exercise 6**: Make a small change to a file. Use `]c` to jump to the change. Use `,hp` to preview the hunk. Use `,hb` to see blame. Try `:Git blame` for full file blame.

---

### 8. Status Line: lualine.nvim (1 slide)
**Primary Use Case**: At-a-glance status info

- Mode indicator (colored)
- Git branch + diff stats
- Diagnostics (errors/warnings)
- File info (encoding, format, type)
- Position in file

---

### 9. Keybinding Discovery: which-key.nvim (1-2 slides)
**Primary Use Case**: Learn and remember keybindings

**How to Use:**
1. Press `,` (leader)
2. Wait ~500ms
3. Popup shows all available mappings with descriptions

**Pro Tip**: Use this constantly when learning - no need to memorize everything!

---

### 10. Code Editing Utilities (2-3 slides)

**Slide 10a - vim-commentary (Comments)**
| Key | Action |
|-----|--------|
| `gcc` | Toggle comment on line |
| `gc` + motion | Comment selection/motion |
| `gcap` | Comment paragraph |

**Slide 10b - vim-surround (Surround Text)**
| Key | Action | Example |
|-----|--------|---------|
| `cs"'` | Change surrounding " to ' | `"hello"` → `'hello'` |
| `ds"` | Delete surrounding " | `"hello"` → `hello` |
| `ysiw"` | Surround word with " | `hello` → `"hello"` |
| `S"` (visual) | Surround selection | Select + `S"` |

**Slide 10c - Other Utilities (Appendix)**
- **lexima.vim**: Auto-closes brackets/quotes
- **vim-repeat**: Makes `.` work with plugin commands
- **vim-endwise**: Auto-adds `end` in Ruby

**Exercise 7**: Select a word, surround it with quotes using `S"`. Change those quotes to backticks with `cs"'`. Comment out a line with `gcc`. Comment out a block with `gc` in visual mode.

---

### 11. Visual Enhancements (1-2 slides)

**Slide 11a - indent-blankline.nvim**
- Shows vertical indent guides
- Highlights current scope
- Helps track nesting level

**Slide 11b - Color Scheme: kanagawa.nvim**
- Modern, warm color scheme
- Good contrast for long coding sessions

---

### 12. Language-Specific Features (2-3 slides)

**Slide 12a - LocalLeader Commands (`,,`)**
| Language | Run | Test | Build |
|----------|-----|------|-------|
| Go | `,,r` (go run) | `,,t` (go test) | `,,b` (go build) |
| Ruby | `,,r` (ruby) | `,,t` (rspec) | - |
| JS | `,,r` (node) | `,,t` (npm test) | - |
| TS | `,,r` (ts-node) | `,,t` (npm test) | - |
| Rust | `,,r` (cargo run) | `,,t` (cargo test) | `,,b` / `,,c` |

**Slide 12b - Indentation Settings**
| Language | Indent |
|----------|--------|
| Go | 4 (tabs) |
| Ruby | 2 (spaces) |
| JS/TS | 2 (spaces) |
| Rust | 4 (spaces) |

**Slide 12c - Markdown Preview**
- `,mp` - Toggle live preview in browser

**Exercise 8**: Open a file in your preferred language. Use `,,r` to run it. Use `,,t` to run tests. (For Go/Rust, try `,,b` to build.)

---

### 13. Navigation & Buffer Management (2 slides)

**Slide 13a - Window Navigation**
| Key | Action |
|-----|--------|
| `Ctrl-h/j/k/l` | Move between windows |
| `Ctrl-d` / `Ctrl-u` | Half-page scroll (centered) |
| `n` / `N` | Search results (centered) |

**Slide 13b - Buffer Management**
| Key | Action |
|-----|--------|
| `,n` / `,p` | Next/previous buffer |
| `,bd` | Delete buffer |
| `,b` | List buffers (fzf) |

---

### 14. Troubleshooting (1-2 slides)

**Common Commands**
| Command | Purpose |
|---------|---------|
| `:CocInfo` | Check LSP status |
| `:CocRestart` | Restart language server |
| `:ALEInfo` | Check linter status |
| `:PlugStatus` | Check plugin status |
| `:checkhealth` | Neovim health check |

---

### 15. Cheat Sheet Summary (1 slide)
Quick reference card with the 10-15 most essential keybindings:
- `,f` - Find files
- `,g` - Grep
- `,gd` - Go to definition
- `K` - Hover docs
- `,ca` - Code actions
- `gcc` - Toggle comment
- `,E` - File tree
- `]c` / `[c` - Git hunks
- `,` + wait - Show all keys

---

## Implementation Details

### reveal.js Setup
- Single HTML file with embedded slides
- Dark theme (black or league) to match code editor aesthetic
- Code syntax highlighting via highlight.js (enabled by default)
- Navigation: arrows, space, or keyboard
- Presenter notes included for live presentation
- Fragment animations for progressive disclosure

### Files to Create
```
slides/
├── index.html              # Main reveal.js presentation (assembled from sections)
├── sections/               # Individual section files (written by subagents)
│   ├── 01-intro.html
│   ├── 02-concepts.html
│   ├── 03-coc-nvim.html
│   ├── 04-ale.html
│   ├── 05-fzf.html
│   ├── 06-nvim-tree.html
│   ├── 07-git.html
│   ├── 08-lualine.html
│   ├── 09-which-key.html
│   ├── 10-editing.html
│   ├── 11-visual.html
│   ├── 12-language.html
│   ├── 13-navigation.html
│   ├── 14-troubleshooting.html
│   └── 15-cheatsheet.html
├── exercises/              # Exercise files for hands-on practice
│   └── ...
└── assets/                 # (optional) Screenshots/diagrams
```

---

## Parallelization Strategy

### Phase 1: Setup (Synchronous - Main Agent)
1. Create `slides/` directory structure
2. Create `slides/index.html` boilerplate with reveal.js setup
3. Create section template with consistent styling

### Phase 2: Section Writing (Parallel - Subagents)
Launch **5 subagents in parallel**, each responsible for a group of related sections:

#### Subagent 1: Core IDE Features
**Files to read:** `nvim/init.vim`, `nvim/coc-settings.json`
**Sections to write:**
- `03-coc-nvim.html` (LSP, completion, diagnostics)
- `04-ale.html` (linting, formatting)

#### Subagent 2: Navigation & Search
**Files to read:** `nvim/init.vim`, `nvim/lua/plugins/nvim-tree.lua`
**Sections to write:**
- `05-fzf.html` (fuzzy finding)
- `06-nvim-tree.html` (file explorer)
- `13-navigation.html` (windows, buffers)

#### Subagent 3: Git & Status
**Files to read:** `nvim/init.vim`, `nvim/lua/plugins/gitsigns.lua`, `nvim/lua/plugins/lualine.lua`
**Sections to write:**
- `07-git.html` (gitsigns, fugitive, rhubarb)
- `08-lualine.html` (status line)

#### Subagent 4: Editing & Visual
**Files to read:** `nvim/init.vim`, `nvim/lua/plugins/which-key.lua`, `nvim/lua/plugins/indent-blankline.lua`
**Sections to write:**
- `09-which-key.html` (keybinding discovery)
- `10-editing.html` (commentary, surround, utilities)
- `11-visual.html` (indent guides, colorscheme)

#### Subagent 5: Language & Reference
**Files to read:** `nvim/ftplugin/*.vim`, `nvim/init.vim`
**Sections to write:**
- `12-language.html` (language-specific features)
- `14-troubleshooting.html` (common commands)
- `15-cheatsheet.html` (quick reference)

### Phase 3: Intro Sections (Synchronous - Main Agent)
Write intro sections that require full context:
- `01-intro.html` (overview, setup)
- `02-concepts.html` (leader keys, philosophy)

### Phase 4: Assembly (Synchronous - Main Agent)
1. Read all section files from `slides/sections/`
2. Assemble into `slides/index.html` in correct order
3. Create exercise files

---

## Subagent Prompt Template

Each subagent receives:
```
You are writing reveal.js slides for a neovim tutorial.

## Your Sections
[List of sections to write]

## Source Files to Read
[List of config files to reference]

## Output Format
Write each section as a standalone HTML file with reveal.js `<section>` tags.
Use this structure for each slide:

<section>
  <h2>Slide Title</h2>
  <!-- content -->
</section>

## Slide Guidelines
- Dark theme assumed (light text on dark background)
- Use <pre><code> for code blocks with class="language-vim" or "language-bash"
- Use <table> for keybinding references
- Keep text minimal, focus on examples
- Include presenter notes: <aside class="notes">...</aside>

## Section Structure
For each plugin section:
1. "What is X?" slide - brief description
2. "Primary Features" slide - must-know keybindings in table
3. "Exercise" slide - hands-on task
4. "Advanced Features" slide (appendix) - additional features

## Exercise Format
<section>
  <h2>Exercise N: [Title]</h2>
  <ol>
    <li>Step one</li>
    <li>Step two</li>
    ...
  </ol>
</section>

Write your sections to: slides/sections/[filename].html
```

---

## Estimated Slide Count
- Introduction: 3 slides
- Essential Concepts: 2 slides
- coc.nvim (LSP): 5 slides
- ALE (Linting): 3 slides
- fzf (Fuzzy Finding): 4 slides
- nvim-tree (File Explorer): 2 slides
- Git Integration: 4 slides
- Status Line: 1 slide
- which-key: 2 slides
- Editing Utilities: 3 slides
- Visual Enhancements: 2 slides
- Language-Specific: 3 slides
- Navigation/Buffers: 2 slides
- Troubleshooting: 2 slides
- Cheat Sheet: 1 slide

**Total: ~39 slides** (with 8 exercises integrated)

### Dependencies
- reveal.js (CDN or local)
- highlight.js (bundled with reveal.js)

---

## Summary

This plan creates a comprehensive reveal.js presentation covering all 25+ plugins in the neovim configuration.

**Parallelization benefits:**
- 5 subagents work concurrently on 13 section files
- Main agent handles setup + 2 intro sections + final assembly
- Each subagent reads only the config files relevant to its sections
- Section files are independent and can be assembled in any order

**Execution flow:**
1. Main: Create directory structure + boilerplate (sync)
2. Subagents 1-5: Write sections in parallel
3. Main: Write intro sections (sync)
4. Main: Assemble final presentation (sync)
