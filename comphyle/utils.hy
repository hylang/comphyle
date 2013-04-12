; (import-from contextlib contextmanagr)


(defn parse-rfc822 [fd]
  "Parse an RFC822 stream"
  (setv bits {})
  (setv key null)
  (for [line fd]
    (if (in ":" line)
      (do
        (setv line (.split line ":" 1))
        (setv key (.strip (get line 0)))
        (setv val (.strip (get line 1)))
        (assoc bits key val))
      (do
        (if (= (.strip line) ".")
          (assoc bits key (+ (get bits key) "\n"))
          (assoc bits key (+ (get bits key) "\n" (.strip line)))))))
  bits)


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
