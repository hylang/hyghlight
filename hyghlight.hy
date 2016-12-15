#!/usr/bin/env hy

(import hy.core)


(defn hyghlight-names []
  (-> (hy.core.reserved.names)
      (sorted)))


(defn generate-highlight-js-file []
  (defn replace-highlight-js-keywords [line]
    (if (in "// keywords" line)
      (+ line
         (.join " +\n"
                (list-comp
                 (.format "{space}'{line} '"
                          :space (* " " 6)
                          :line (.join " " keyword-line))
                 [keyword-line (partition (hyghlight-names) 10)])))
      line))

  (with [f (open "templates/highlight_js/hy.js")]
        (.join ""
               (list-comp (replace-highlight-js-keywords line)
                          [line (.readlines f)]))))


(defmain [&rest args]
  (let [highlight-library (second args)]
    (print (cond
            [(= highlight-library "highlight.js")
             (generate-highlight-js-file)]
            [True "Usage: hy hyghlight.hy [highlight.js]"]))))
