#lang racket

(provide (contract-out [DEBUG (parameter/c boolean?)]))
(define/contract DEBUG
  (parameter/c boolean?)
  (make-parameter #t))