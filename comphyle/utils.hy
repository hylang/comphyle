(import requests)
 

(defn parse-rfc822 [fd]
  "Parse an RFC822 stream"
  (setv ret [])
  (setv bits {})
  (setv key null)
  (for [line fd]
    (if (= (.strip line) "")
      (do
        (.append ret bits)
        (setv bits {})
        (setv key null))
      (if (not (.startswith line " "))
        (do
          (setv (, key val) (list-comp (.strip x) [x (.split line ":" 1)]))
          (assoc bits key val))
        (do
          (if (= (.strip line) ".")
            (assoc bits key (+ (get bits key) "\n"))
            (assoc bits key (+ (get bits key) "\n" (.strip line))))))))
  (if (!= bits {}) (.append ret bits))
  ret)


;http://archive.pault.ag/dists/wicked/main/binary-i386/
(defn read-repo-contents [repo suite section arch]
  (setf url (.format "{0}/dists/{1}/{2}/binary-{3}/Packages" repo suite section arch))
  (setv req (.get requests url))
  (if (!= req.status_code 200)
    (throw (IOError "Site sucks.")))
  (parse-rfc822 (.splitlines req.text)))
