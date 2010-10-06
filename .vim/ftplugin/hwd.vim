" Only run this file once per buffer
if exists("b:did_hwd_ftplugin")
    finish
endif
let b:did_hwd_ftplugin = 1

map  <buffer> \2 :!hwd --nostrict --todo % \| less<CR>
map  <buffer> \3 :!hwd --nostrict % \| less +G<CR>
