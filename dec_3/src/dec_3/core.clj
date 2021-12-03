(ns dec-3.core
  (:gen-class))

(defn parse_number
  [number]
  [
    bit-and number (bit-shift-left 1 0)
    bit-and number (bit-shift-left 1 1)
    bit-and number (bit-shift-left 1 2)
    bit-and number (bit-shift-left 1 3)
    bit-and number (bit-shift-left 1 4)
  ])

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (println "Hello, World!"))
