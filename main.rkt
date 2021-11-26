#lang at-exp racket

;; Copyright 2020 Justin Hu
;;
;; This file is part of Racket to JS.
;;
;; Racket to JS is free software: you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free Software
;; Foundation, either version 3 of the License, or (at your option) any later
;; version.
;;
;; Racket to JS is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
;; FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
;; details.
;;
;; You should have received a copy of the GNU General Public License along with
;; Racket to JS. If not see <https://www.gnu.org/licenses/>.
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

(require "compiler.rkt")
(require "errors.rkt")
(require "options.rkt")
(require "version.rkt")

(require racket/cmdline)

(command-line
 #:program "racket2js"

 #:once-any
 [("--debug") "compile with debug printing" (DEBUG #t)]
 [("--no-debug") "compile without debug printing" (DEBUG #f)]

 #:once-each
 [("-v" "--version") "show version info"
  (displayln @string-append{
   racket2js version @|VERSION|
   Copyright 2021 Justin Hu
   This is free software; see the source for copying conditions. There is NO
   warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.})]

 #:args filenames
 (for ([filename filenames])
   (with-handlers ([exn:fail:filesystem?
                    (thunk* (displayln (format "~a: error: could not open file; ensure the file exists" filename)))]
                   [exn:fail:read?
                    (thunk* (displayln (format "~a: error: could not read file; ensure the file runs" filename)))]
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
            (displayln (format "DEBUG: module = ~a" module)))
          (let ([compiled (racket->js module)])
            (call-with-output-file*
             (string-append filename ".js")
             (λ (out-file)
               (write-string compiled out-file))
             #:mode 'text
             #:exists 'truncate/replace))))
       #:mode 'text))))