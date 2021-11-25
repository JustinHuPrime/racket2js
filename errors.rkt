#lang racket

(provide (contract-out (struct exn:compiler ([message string?]))))
(struct/contract exn:compiler ([message string?])
  #:transparent)