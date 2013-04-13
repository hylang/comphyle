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
