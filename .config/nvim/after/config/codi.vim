let g:codi#interpreters = {
      \ 'python': {
          \ 'bin': 'python',
          \ 'prompt': '^\(>>>\|\.\.\.\) ',
          \ },
      \ 'javascript': {
          \ 'bin': 'node',
          \ 'prompt': '^\(>\|\.\.\.\+\) ',
          \ },
      \ 'coffee': {
          \ 'bin': 'coffee',
          \ 'prompt': '^coffee> ',
          \ },
      \ 'haskell': {
          \ 'bin': 'ghci',
          \ 'prompt': '^Prelude[^>|]*[>|] ',
          \ },
      \ 'clojure': {
          \ 'bin': ['lein', 'repl'], 
          \ 'prompt': '^.\{-}=> ',
          \ },
      \ 'lua': {
          \ 'bin': ['lua'],
          \ 'prompt': '^\(>\|>>\) ',
          \ },
      \ }
