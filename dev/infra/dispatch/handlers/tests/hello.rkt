#!/usr/bin/env racket
#lang racket/base
;; quicktest: smoke test for application/x-racket handler
;; Skip if racket is not installed:
;;   dispatch.sh --mime application/x-racket dev/infra/dispatch/handlers/tests/hello.rkt
(displayln "hello from racket")
