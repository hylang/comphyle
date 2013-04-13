; (import-from contextlib contextmanagr)


(defn parse-rfc822 [fd]
  "Parse an RFC822 stream"
  (setv ret [])
  (setv bits {})
  (setv key null)
  (for [line fd]
    (if (= (.strip line) "")
      (do
        (.append ret bits)
        (setv bits {}))
      (if (in ":" line)
        (do
          (setv line (.split line ":" 1))
          (setv key (.strip (get line 0)))
          (setv val (.strip (get line 1)))
          (assoc bits key val))
        (do
          (if (= (.strip line) ".")
            (assoc bits key (+ (get bits key) "\n"))
            (assoc bits key (+ (get bits key) "\n" (.strip line))))))))
  (if (!= bits {}) (.append ret bits))
  ret)


; XXX: blocked by finally PR from @jd
;(decorate-with contextmanager
;(defn cd [path]
;  (setf old-dir (.getcwd os))
;  (.chdir os path)
;  (try (yield) (finally (.chdir os old-dir)))))


;; to port
;; @contextmanager
;; def cd(path):
;;     old_dir = os.getcwd()
;;     os.chdir(path)
;;     try:
;;         yield
;;     finally:
;;         os.chdir(old_dir)
;; 
;; 
;; @contextmanager
;; def tmpdir():
;;     path = tempfile.mkdtemp()
;;     try:
;;         yield path
;;     finally:
;;         pass
;;     rmdir(path)
