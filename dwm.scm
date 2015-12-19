(use-modules (json))

(define cs-norm (dwm-make-colorscheme "#000" "#ccc"))
(define cs-selected (dwm-make-colorscheme "#fff" "#666"))
(define cs-separator (dwm-make-colorscheme "#666" "#ccc"))
(define cs-separator-selected (dwm-make-colorscheme "#ccc" "#666"))

(define (dwm-notify text)
  (dwm-spawn "notify-send" (string-append " " text " ")))

(dwm-notify "(Re)loaded config")

(define (plain maxw)
  (let* ((s (dwm-status-text))
         (w (dwm-drw-textw s))
         (x (- maxw w (dwm-systray-width))))
    (dwm-drw-set-colorscheme cs-norm)
    (dwm-drw-text x w s)
    x))

(define order
  '(("date" . ("#005faf" . "#0087d7"))
    ("net" . ("#5F5F5F" . "#878787"))
    ("apm". ("#008700" . "#00AF00"))
    ("weather". ("#AF0000" . "#D70000"))
    ("mpd" . ("#AF5F00" . "#D78700"))
    ("err" . ("#400" . "#700"))))

(define (get-items order data accum)
  (if (null? order)
    accum
    (let* ((item (car order))
           (title (car item))
           (colors (cdr item))
           (x (hash-ref data title)))
      (get-items (cdr order) data
                 (if x
                   (append accum (list (cons x colors)))
                   accum)))))

(define (draw-single-item maxx item prevbg)
  (let* ((d "")
         (dw (dwm-drw-textw d #t))
         (t (car item))
         (c (cdr item))
         (tw (dwm-drw-textw t))
         (dx (- maxx (if prevbg dw 0)))
         (tx (- dx tw)))
    (when prevbg
      (dwm-drw-set-colorscheme (dwm-make-colorscheme prevbg (car c)))
      (dwm-drw-text dx dw d #f #t))
    (dwm-drw-set-colorscheme (dwm-make-colorscheme "#fff" (car c)))
    (dwm-drw-text tx tw t)
    (dwm-drw-set-colorscheme (dwm-make-colorscheme (car c) (cdr c)))
    (dwm-drw-text (- tx dw) dw d #f #t)
    (cons (- tx dw) (cdr c))))

(define (draw-items maxx items prevbg)
  (if (null? items)
    maxx
    (let* ((i (draw-single-item maxx (car items) prevbg))
           (bg (cdr i)))
      (draw-items (car i) (cdr items) (cdr i)))))

(dwm-hook-drawstatus
  (lambda (x maxw sel)
    (format #t "S: ~s\n" (dwm-status-text))
    (let*  ((d "")
            (dw (dwm-drw-textw d #t))
            (s (dwm-status-text))
            (data (catch #t
                         (lambda ()
                           (json-string->scm s))
                         (lambda (key . p)
                           (let ((h (make-hash-table 1)))
                            (hash-set! h "err" "Invalid JSON")
                            h))))
            (items (get-items order data '()))
            (x (draw-items maxw items #f)))
      (let ((c (cdr (car (reverse items)))))
       (dwm-drw-set-colorscheme (dwm-make-colorscheme (cdr c) (if sel "#666" "#ccc")))
       (dwm-drw-text (- x dw) dw d #f #t))
      (- x dw))))
