(ns dec-3.core
  (:gen-class))


(defn simplify
  [number]
  (if (not= number 0) 1 0))

(defn parse_number_to_arr
  [number]
  (map
    (comp simplify (partial bit-and number) (partial bit-shift-left 1))
    [11 10 9 8 7 6 5 4 3 2 1 0]))

(defn parse_arr_to_number
  [arr]
  (defn f
    [a b]
    (+ (* a 2) (if b 1 0)))
  (reduce f 0 arr))

(defn parse_bin
  [s]
  (Integer/parseInt s 2))

(defn split_lines
  [s]
  (clojure.string/split-lines s))

(defn part1
  [input]
  (def step1 (map (comp parse_number_to_arr parse_bin) input))
  (def step2 (reduce (partial map +) [0 0 0 0 0 0 0 0 0 0 0 0] step1))
  (def step3 (clojure.core/count step1))
  (def step4 (map (partial < (/ step3 2)) step2))
  (println step2)
  (def step5 (parse_arr_to_number step4))
  (* step5 (bit-and 2r111111111111 (bit-not step5))))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (def input (line-seq (java.io.BufferedReader. *in*)))
  (println (part1 input)))

(def test_case
"00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010")
