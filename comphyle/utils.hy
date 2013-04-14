(import-from StringIO StringIO)
(import-from comphyle.native V)

(import requests)
(import gzip)
 

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


(defn read-repo-contents [repo suite section]
  (setf url (.format "{0}/dists/{1}/{2}/source/Sources.gz"
                     repo suite section))
  (setv req (.get requests url))
  (if (!= req.status_code 200)
    (throw (IOError "Site sucks.")))

  (parse-rfc822 (.splitlines (.read (kwapply (.GzipFile gzip)
                                {"fileobj" (StringIO req.content)})))))


(defn needs-build [repo suite section config]
  (def remote (filter (lambda [x] (= (get x "Package")
                                     (get (get config "config") "Source")))
                              (read-repo-contents repo suite section)))
  (if (= remote [])
    true
    (do
      (setf versions (map (lambda [x] (V (get x "Version"))) remote))
      (if (> (V (get config "version")) (max versions)) true false))))
