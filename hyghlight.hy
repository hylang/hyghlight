#!/usr/bin/env hy

(import hy.core)


(defn hyghlight-names []
  (-> (hy.core.reserved.names)
      (sorted)))


(defn hyghlight-keywords []
  (sorted hy.core.reserved.keyword.kwlist))


(defn hyghlight-builtins []
  (sorted
   (- (hy.core.reserved.names)
      (frozenset hy.core.reserved.keyword.kwlist))))


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


(defn generate-rouge-file []
  (defn replace-rouge-keywords [line]
    (cond
     [(in "@keywords" line) (+ line
                                (.join "\n"
                                       (list-comp
                                        (.format "{space}{line}"
                                                 :space (* " " 10)
                                                 :line (.join " " keyword-line))
                                        [keyword-line (partition (hyghlight-keywords) 10)]))
                                "\n")]
     [(in "@builtins" line) (+ line
                                (.join "\n"
                                       (list-comp
                                        (.format "{space}{line}"
                                                 :space (* " " 10)
                                                 :line (.join " " keyword-line))
                                        [keyword-line (partition (hyghlight-builtins) 10)]))
                                "\n")]
     [True line]))

  (with [f (open "templates/rouge/hylang.rb")]
        (.join ""
               (list-comp (replace-rouge-keywords line)
                          [line (.readlines f)]))))


(defmain [&rest args]
  (let [highlight-library (second args)]
    (print (cond
            [(= highlight-library "highlight.js")
             (generate-highlight-js-file)]
            [(= highlight-library "rouge")
             (generate-rouge-file)]
            [True "Usage: hy hyghlight.hy [highlight.js | rouge]"]))))
