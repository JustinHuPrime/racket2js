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

(require "errors.rkt")
(require "options.rkt")
(require "version.rkt")

(define/contract stab?
  contract?
  (hash/c symbol? string?))

(define/contract PREAMBLE
  string?
  @string-append{
 // This file was generated using racket2js version @VERSION @"\n\n"})

(define/contract (compile-define who what stab)
  (-> any/c any/c stab? (list/c stab? string?))
  (list stab "TODO"))

(define/contract (compile-expr expr stab)
  (-> any/c stab? (list/c stab? string?))
  (list stab "TODO"))

(define/contract (compile-form form stab)
  (-> any/c stab? (list/c stab? string?))
  (match form
    [`(define ,who ,what)
     (compile-define who what stab)]
    [`,expr
     (compile-expr expr stab)]))

(provide (contract-out [racket->js (value-contract racket->js)]))
(define/contract (racket->js module)
  (-> any/c string?)
  (match module
    [`(module ,id ,module-path (#%module-begin . ,forms))
     #:when (list? forms)
     (when (DEBUG)
       (displayln (format "DEBUG: id          = ~a" id))
       (displayln (format "DEBUG: module-path = ~a" module-path))
       (displayln (format "DEBUG: forms       = ~a" forms)))
     (unless (or (equal? module-path 'racket)
                 (equal? module-path 'racket/base))
       (raise (exn:compiler "expected the module language to be racket or racket/base")))
     (string-join (for/fold ([stab (hash)]
                             [compiled (list)]
                             #:result (reverse compiled))
                            ([form forms])
                    (match-let ([`(,stab ,compiled-form) (compile-form form stab)])
                      (values stab (cons compiled-form compiled))))
                  "\n"
                  #:before-first PREAMBLE)]
    [_ (raise (exn:compiler "expected a module definition"))]))