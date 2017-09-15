" Setup incrementing of some search results.
command! -nargs=* Incrementor call david#incrementor#reset_incrementing_number(<f-args>)
