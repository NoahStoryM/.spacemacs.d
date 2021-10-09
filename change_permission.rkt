#lang typed/racket


(: deal-file [-> Path Void])
(define deal-file
  (λ (file-path)
    (define file-name (path->string file-path))

    (when (or (string-suffix? file-name ".org")
              (string-suffix? file-name ".el")
              (string-suffix? file-name ".c")
              (string-suffix? file-name ".cc")
              (string-suffix? file-name ".py")
              (string-suffix? file-name ".java")
              (string-suffix? file-name ".rkt")
              (string-suffix? file-name ".markdown")
              (string-suffix? file-name ".md")
              (string-suffix? file-name ".js"))

      (void (system (format "chmod -R 644 ~a" file-name))))))

(: deal-dir [-> Path Void])
(define deal-dir
  (λ (dir-path)
    (for ([path (directory-list dir-path #:build? #t)])
      (cond [(and (file-exists? path)
                  (string-suffix? (path->string path) ".el"))
             (displayln (format "deal file: ~a" path))
             (deal-file path)]
            [(directory-exists? path)
             (displayln "\n----------------------------------------------------------------------")
             (displayln (format "deal files under: ~a" path))
             (deal-dir path)]
            [else
             (displayln "\n**********************************************************************")
             (displayln (format "~a is not a directory or a file!" path))
             (displayln "\n**********************************************************************")]))))


(: main [-> String * (Values Any)])
(define main
  (λ argv
    (when (null? argv)
      (set! argv (vector->list (current-command-line-arguments))))

    (deal-dir (string->path "."))

    (values 0)))
(module+ main (call-with-values (λ () (main)) exit))
