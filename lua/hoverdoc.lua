-- Documentation for the word under the cursor: LSP hover, plus gi-docgen HTML
-- (glib2-docs, gtk4-docs, ...) or a man page, rendered as markdown into one popup.
local M = {}

local kinds = {
    ['function'] = 'func',
    function_macro = 'func',
    bitfield = 'flags',
    constant = 'const',
    domain = 'error',
    record = 'struct',
    interface = 'iface',
}

-- sections worth showing in a hover; everything else (Hierarchy, Instance methods,
-- Properties, Signals, ...) is a navigation listing and gets dropped.
local keep_section = {
    ['Declaration'] = true,
    ['Description'] = true,
    ['Parameters'] = true,
    ['Return value'] = true,
    ['Members'] = true,
    ['Fields'] = true,
    ['Flags'] = true,
}

local drop_section = {
    ['Ancestors'] = true, ['Descendants'] = true, ['Hierarchy'] = true,
    ['Implements'] = true, ['Implementations'] = true, ['Prerequisite'] = true,
    ['Constructors'] = true, ['Functions'] = true, ['Instance methods'] = true,
    ['Class methods'] = true, ['Virtual methods'] = true, ['Class structure'] = true,
    ['Properties'] = true, ['Signals'] = true, ['See also'] = true,
}

-- Where gi-docgen output lands differs per distro: Arch keeps it flat in
-- /usr/share/doc/<ns>/, Debian nests it under a package directory, and Nix puts
-- it in the store, reachable through the profile's share dirs.
local function doc_roots()
    local seen, roots = {}, {}
    local candidates = vim.split(vim.env.XDG_DATA_DIRS or '', ':', { trimempty = true })
    vim.list_extend(candidates, {
        '/usr/share', '/usr/local/share',
        '/run/current-system/sw/share',
        vim.fn.expand('~/.nix-profile/share'),
    })
    for _, dir in ipairs(candidates) do
        dir = dir:gsub('/$', '') .. '/doc'
        if not seen[dir] and vim.fn.isdirectory(dir) == 1 then
            seen[dir] = true
            roots[#roots + 1] = dir
        end
    end
    return roots
end

local index
local roots

local function build()
    index = {}
    roots = doc_roots()
    local found = #roots > 0
        and vim.fn.systemlist(vim.list_extend({ 'find', '-L' }, vim.list_extend(vim.deepcopy(roots),
            { '-maxdepth', '3', '(', '-name', 'index.json', '-o', '-name', 'index.json.gz', ')' })))
        or {}
    for _, json in ipairs(found) do
        -- `find -L` can hit filesystem loops (e.g. node package doc symlinks) and
        -- emit an error line on stdout instead of a path; skip anything bogus.
        local ok, data = false, nil
        if vim.fn.filereadable(json) == 1 then
            ok, data = pcall(function()
                local content
                if json:match('%.gz$') then
                    content = table.concat(vim.fn.systemlist({ 'gzip', '-dc', json }), '\n')
                    if vim.v.shell_error ~= 0 then error('gzip failed') end
                else
                    content = table.concat(vim.fn.readfile(json), '\n')
                end
                return vim.json.decode(content)
            end)
        end
        if ok and data.symbols then
            local dir = vim.fs.dirname(json)
            for _, s in ipairs(data.symbols) do
                local key = s.ident or s.ctype
                if key then
                    local kind = kinds[s.type] or s.type
                    local file
                    if s.type_name then
                        local owner = s.type == 'class_method' and s.type_name:gsub('Class$', '') or s.type_name
                        file = string.format('%s.%s.%s.html', kind, owner, s.name)
                    else
                        file = string.format('%s.%s.html', kind, s.name)
                    end
                    index[key] = dir .. '/' .. file
                end
            end
        end
    end
end

local function dump(path, width)
    if vim.fn.executable('w3m') == 0 then
        vim.notify_once('hoverdoc: w3m is not installed; HTML docs unavailable', vim.log.levels.WARN)
        return {}
    end
    return vim.fn.systemlist(string.format(
        [[sed -n '/<section id="main" class="content">/,/<section id="search"/p' %s | w3m -dump -T text/html -cols %d]],
        vim.fn.shellescape(path), width))
end

local function to_markdown(symbol, raw, opts)
    local i = 1
    while raw[i] and raw[i]:match('^%s*$') do i = i + 1 end
    local kind = raw[i] and vim.trim(raw[i]) or ''
    i = i + 1
    while raw[i] and raw[i]:match('^%s*$') do i = i + 1 end
    i = i + 1 -- the title line repeats the symbol with the namespace glued on

    local out = { '**' .. symbol .. '** — *' .. kind .. '*' }
    local keep, fenced, code = true, false, false
    for j = i, #raw do
        local line = raw[j]:gsub('%s*%[src%]%s*$', ''):gsub('%s+$', '')
        local head = vim.trim(line)
        if keep_section[head] or drop_section[head] then
            if fenced then
                out[#out + 1] = '```'
                fenced = false
            end
            keep = opts.full or ((keep_section[head] and not opts.skip[head]) or false)
            if keep then
                out[#out + 1] = ''
                out[#out + 1] = '## ' .. head
                if head == 'Declaration' then
                    out[#out + 1] = '```c'
                    fenced, code = true, false
                end
            end
        elseif fenced then
            if head == '' then
                if code then                 -- blank line ends the declaration block
                    out[#out + 1] = '```'
                    fenced = false
                end
            else
                out[#out + 1] = line
                code = true
            end
        elseif keep then
            line = line:gsub('^(%s*)• ', '%1- '):gsub('^(%s*)☆ ', '%1- ')
            local dep = head:match('^[Dd]eprecated:%s*(.+)$')
            out[#out + 1] = dep and ('> **Deprecated since ' .. dep .. '**') or line
        end
    end
    if fenced then out[#out + 1] = '```' end
    while out[#out] and out[#out]:match('^%s*$') do out[#out] = nil end
    return out
end

--- Markdown lines for `symbol`, or nil when it has no gi-docgen page.
--- `opts.skip` is a set of section names to leave out; `opts.full` keeps every
--- section, including the navigation listings a hover has no room for.
function M.docs(symbol, width, opts)
    if not index then build() end
    local path = index[symbol]
    if not path then return nil end
    local raw = dump(path, width or 78)
    if #raw == 0 then return nil end
    opts = opts or {}
    opts.skip = opts.skip or {}
    return to_markdown(symbol, raw, opts), path
end

-- Tier 3: man(3)/man(2) pages, for the C libraries that document themselves there
-- (curl, openssl, sd-bus, libc with man-pages installed) instead of in HTML.
local keep_man = {
    NAME = 'Name',
    DESCRIPTION = 'Description',
    ['RETURN VALUE'] = 'Return value',
    ERRORS = 'Errors',
}

local function man_markdown(symbol, raw, opts)
    local out, keep = {}, false
    for _, line in ipairs(raw) do
        local head = line:match('^(%u[%u%s()/-]*%u)%s*$') or line:match('^(NAME)%s*$')
        if head then
            local title = keep_man[head] or (opts.full and head:sub(1, 1) .. head:sub(2):lower())
            keep = title ~= nil and not opts.skip[title]
            if keep then
                out[#out + 1] = ''
                out[#out + 1] = '## ' .. title
            end
        elseif keep then
            out[#out + 1] = line
        end
    end

    -- man indents its body; strip whatever the page happens to use
    local indent = math.huge
    for _, line in ipairs(out) do
        if not line:match('^%s*$') and not line:match('^## ') then
            indent = math.min(indent, #line:match('^ *'))
        end
    end
    if indent > 0 and indent < math.huge then
        for k, line in ipairs(out) do
            if not line:match('^## ') then out[k] = line:sub(indent + 1) end
        end
    end
    while out[1] and out[1]:match('^%s*$') do table.remove(out, 1) end
    while out[#out] and out[#out]:match('^%s*$') do out[#out] = nil end
    if #out == 0 then return nil end
    table.insert(out, 1, '**' .. symbol .. '** — *man page*')
    return out
end

--- Markdown lines for `symbol`'s man page, or nil when it has none.
function M.man(symbol, width, opts)
    if vim.fn.executable('man') == 0 or vim.fn.executable('col') == 0 then return nil end
    local page = vim.fn.systemlist({ 'man', '-w', '-S', '3:2', symbol })
    if vim.v.shell_error ~= 0 or #page == 0 then return nil end
    local raw = vim.fn.systemlist(string.format('MANWIDTH=%d man --nh --nj -S 3:2 %s 2>/dev/null | col -bx',
        width or 78, vim.fn.shellescape(symbol)))
    opts = opts or {}
    opts.skip = opts.skip or {}
    return man_markdown(symbol, raw, opts)
end

local function open(lines, width, symbol)
    local from = vim.api.nvim_get_current_win()
    local preview = lines
    local buf, win = vim.lsp.util.open_floating_preview(lines, 'markdown', {
        border = 'rounded',
        wrap = true,
        max_width = width,
        max_height = math.floor(vim.o.lines * 0.6),
        focus_id = 'hoverdoc',
    })
    if symbol then
        -- <CR> in the popup opens the whole page in a buffer
        vim.keymap.set('n', '<CR>', function()
            if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
            if vim.api.nvim_win_is_valid(from) then vim.api.nvim_set_current_win(from) end
            M.buffer(symbol, preview)
        end, { buffer = buf, desc = 'Open full documentation' })

        -- ... and <CR> in the code buffer focuses the popup, so it takes two
        -- presses to get there. Both are undone when the popup goes away.
        local code = vim.api.nvim_win_get_buf(from)
        local saved = vim.fn.maparg('<CR>', 'n', false, true)
        vim.keymap.set('n', '<CR>', function()
            if vim.api.nvim_win_is_valid(win) then vim.api.nvim_set_current_win(win) end
        end, { buffer = code, desc = 'Focus documentation popup' })

        vim.api.nvim_create_autocmd('WinClosed', {
            pattern = tostring(win),
            once = true,
            callback = function()
                pcall(vim.keymap.del, 'n', '<CR>', { buffer = code })
                if saved.buffer == 1 and vim.api.nvim_buf_is_valid(code) then
                    vim.api.nvim_buf_call(code, function() vim.fn.mapset(saved) end)
                end
            end,
        })
    end
    return buf, win
end

--- The whole page for `symbol`, in a normal buffer: `<C-o>` or `q` goes back.
--- Symbols with no page of their own (`gchar`, anything in this project) fall
--- back to `preview`, the text the popup was showing.
function M.buffer(symbol, preview)
    local width = math.min(100, vim.api.nvim_win_get_width(0) - 6)
    local lines = M.docs(symbol, width, { full = true })
        or M.man(symbol, width, { full = true })
        or preview
    if not lines or #lines == 0 then
        return vim.notify('hoverdoc: no docs for ' .. symbol, vim.log.levels.WARN)
    end

    local name = 'doc://' .. symbol
    local buf = vim.fn.bufnr(name)
    if buf == -1 then
        buf = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_buf_set_name(buf, name)
    end
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.bo[buf].modified = false
    vim.bo[buf].buftype = 'nofile'
    vim.bo[buf].bufhidden = 'hide'
    vim.bo[buf].filetype = 'markdown'
    vim.keymap.set('n', 'q', function()
        if vim.fn.buflisted(vim.fn.bufnr('#')) == 1 then
            vim.cmd('buffer #')
        else
            vim.cmd('bdelete')
        end
    end, { buffer = buf, desc = 'Back to code' })

    vim.cmd("normal! m'")   -- leave a jumplist entry so <C-o> comes back here
    vim.api.nvim_win_set_buf(0, buf)
    vim.wo.wrap = true
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
end

--- Drop-in for K: LSP hover, with gi-docgen docs appended when they exist.
function M.hover()
    local symbol = vim.fn.expand('<cword>')
    local width = math.min(90, vim.o.columns - 6)
    local params = vim.lsp.util.make_position_params(0, 'utf-16')

    vim.lsp.buf_request_all(0, 'textDocument/hover', params, function(results)
        local lines = {}
        for _, res in pairs(results) do
            if res.result and res.result.contents then
                vim.list_extend(lines, vim.lsp.util.convert_input_to_markdown_lines(res.result.contents))
            end
        end
        lines = vim.split(table.concat(lines, '\n'), '\n', { trimempty = true })

        local docs = M.docs(symbol, width - 4, { skip = #lines > 0 and { Declaration = true } or {} })
            or M.man(symbol, width - 4, { skip = #lines > 0 and { Name = true } or {} })
        if docs then
            if #lines > 0 then vim.list_extend(lines, { '', '---', '' }) end
            vim.list_extend(lines, docs)
        end

        if #lines == 0 then
            return vim.notify('No hover or docs for ' .. symbol, vim.log.levels.WARN)
        end
        open(lines, width, symbol)
    end)
end

--- Explicit lookup, with substring and full-text fallbacks.
function M.lookup(symbol)
    symbol = (symbol and symbol ~= '') and symbol or vim.fn.expand('<cword>')
    if not index then build() end
    local width = math.min(90, vim.o.columns - 6)
    if index[symbol] then return open(M.docs(symbol, width - 4), width, symbol) end

    local matches = {}
    for key in pairs(index) do
        if key:lower():find(symbol:lower(), 1, true) then matches[#matches + 1] = key end
    end

    if #matches == 0 then
        -- enum members and other symbols documented inside a page: find pages
        -- mentioning it, ranked so the type that owns it comes first.
        local by_path, rank = {}, { enum = 1, flags = 2, const = 3 }
        for key, path in pairs(index) do by_path[path] = key end
        local scored = {}
        local cmd = { 'grep', '-rlw', '--include=*.html', symbol }
        for _, root in ipairs(roots or {}) do cmd[#cmd + 1] = root end
        for _, path in ipairs(vim.fn.systemlist(cmd)) do
            local key = by_path[path]
            if key then
                scored[#scored + 1] = { key = key, rank = rank[vim.fs.basename(path):match('^%a+')] or 9 }
            end
        end
        table.sort(scored, function(a, b)
            if a.rank ~= b.rank then return a.rank < b.rank end
            return #a.key < #b.key
        end)
        for _, m in ipairs(scored) do matches[#matches + 1] = m.key end
    else
        table.sort(matches, function(a, b) return #a < #b end)
    end

    if #matches == 0 then
        return vim.notify('hoverdoc: no docs for ' .. symbol, vim.log.levels.WARN)
    end
    if #matches == 1 then return open(M.docs(matches[1], width - 4), width, matches[1]) end
    vim.ui.select(matches, { prompt = 'hoverdoc: ' .. symbol }, function(m)
        if m then open(M.docs(m, width - 4), width, m) end
    end)
end

return M
