#lang racket

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

(provide (contract-out (struct exn:compiler ([message string?]))))
(struct/contract exn:compiler ([message string?])
  #:transparent)