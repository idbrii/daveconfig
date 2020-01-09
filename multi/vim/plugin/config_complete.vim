" Configuration for asyncomplete

if !has('timers')
    let g:asyncomplete_loaded = 0
    finish
endif

" See also after/plugin/zpersonalized.vim

augroup david_complete
    au!

    au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
                \ 'name': 'tags',
                \ 'whitelist': ['c'],
                \ 'completor': function('asyncomplete#sources#tags#completor'),
                \ 'config': {
                \    'max_file_size': 50000000,
                \  },
                \ }))

augroup END
