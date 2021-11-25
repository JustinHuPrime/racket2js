#lang racket

(require "compiler.rkt")
(require "errors.rkt")
(require "options.rkt")

(require racket/cmdline)

(command-line
 #:args filenames
 (for ([filename filenames])
   (with-handlers ([exn:fail:filesystem?
                    (thunk* (displayln (format "could not open ~a; ensure the file exists" filename)))]
                   [exn:fail:read?
                    (thunk* (displayln (format "could not read ~a; ensure the file runs" filename)))]
                   [exn:compiler?
                    (λ (e)
                      (displayln (format "~a: error: ~a" filename (exn:compiler-message e))))])
     (with-input-from-file filename
       (thunk
        (let ([module (parameterize ([read-accept-lang #t]
                                     [read-accept-reader #t])
                        (read))])
          (unless (eof-object? (read))
            (raise (exn:compiler (format "expected only one module per file"))))
          (when (DEBUG)
            (displayln (format "DEBUG: ~a" module)))
          (let ([compiled (racket->js module)])
            (call-with-output-file*
             (string-append filename ".js")
             (λ (out-file)
               (write-string compiled out-file))
             #:mode 'text
             #:exists 'truncate/replace))))
       #:mode 'text))))