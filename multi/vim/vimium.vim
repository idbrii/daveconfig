" Bindings to make vimium work like vim and nothing else.
" Avoid any surprise functionality.

unmapAll

map j scrollDown
map k scrollUp
map gg scrollToTop
map G scrollToBottom
" map U scrollPageDown
" map D scrollPageUp
" map x scrollFullPageDown
" map x scrollFullPageUp
map l scrollLeft
map h scrollRight
" map :e reload
" map x copyCurrentUrl
" map x openCopiedUrlInCurrentTab
" map x openCopiedUrlInNewTab
map i enterInsertMode
map v enterVisualMode
" map f focusInput
" map x nextFrame
" map x mainFrame
map / enterFindMode
map n performFind
map N performBackwardsFind
" map x goBack
" map x goForward
" map x createTab
map gT previousTab
map gt nextTab
" map x visitPreviousTab
" map x firstTab
" map x lastTab
" map x duplicateTab
" map x togglePinTab
" map x toggleMuteTab
" map x removeTab
map u restoreTab

" LinkHints are vim-EasyMotion
map f LinkHints.activateMode
"~ map x LinkHints.activateModeToOpenInNewForegroundTab

map <C-Space> Vomnibar.activate
"~ map x Vomnibar.activateInNewTab
"~ map x Vomnibar.activateBookmarks
"~ map x Vomnibar.activateBookmarksInNewTab
"~ map x Vomnibar.activateTabSelection

" Advanced
"
"~ map x LinkHints.activateModeToCopyLinkUrl
"~ map x LinkHints.activateModeToDownloadLink
"~ map x LinkHints.activateModeToOpenIncognito
"~ map x LinkHints.activateModeWithQueue
"~ map x Marks.activateCreateMode
"~ map x Marks.activateGotoMode
"~ map x Vomnibar.activateEditUrl
"~ map x Vomnibar.activateEditUrlInNewTab
"~ map x closeOtherTabs
"~ map x closeTabsOnLeft
"~ map x closeTabsOnRight
map V enterVisualLineMode
"~ map x goToRoot
"~ map x goUp
"~ map x moveTabLeft
"~ map x moveTabRight
map <C-w>T moveTabToNewWindow
"~ map x passNextKey
"~ map x scrollToLeft
"~ map x scrollToRight
"~ map x toggleViewSource

" Nonstandard
map g? showHelp
map gf LinkHints.activateModeToOpenInNewTab
map <C-x><C-s> goNext
map <C-x><C-x> goPrevious
