#lang racket

(provide (contract-out [racket->js (-> (listof any/c) string?)]))
(define/contract (racket->js file)
  (-> any/c string?)
  "TODO")