(ns dec-3.core
  (:gen-class))


(defn simplify
  [number]
  (if (not= number 0) 1 0))

(defn long-bool-cast
  [number]
  (not= number 0))

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

(defn filter-lines
  [bit input f]
  (def input-length
    (count input))
  (if
    (or
      (= input-length 0)
      (> bit 12))
    nil
    (if
      (= input-length 1)
      input
      (let [sum (reduce + 0 (map (fn [line] (nth line bit)) input))
            most-common-bit (if (f sum (/ input-length 2)) 1 0)
            remaining-lines (filter
              (fn [line] (= (nth line bit) most-common-bit))
              input)]
        (filter-lines (+ bit 1) remaining-lines f)))))

(defn part1
  [input]
  (def step1 (map (comp parse_number_to_arr parse_bin) input))
  (def step2 (reduce (partial map +) [0 0 0 0 0 0 0 0 0 0 0 0] step1))
  (def step3 (count step1))
  (def step4 (map (partial < (/ step3 2)) step2))
  (def step5 (parse_arr_to_number step4))
  (* step5 (bit-and 2r111111111111 (bit-not step5))))

(defn part2
  [input]
  (let [parsed_inputs (map (comp parse_number_to_arr parse_bin) input)
        oxygen_bin (vec (first (filter-lines 0 parsed_inputs <)))
        co2_bin (vec (first (filter-lines 0 parsed_inputs >=)))
        oxygen (parse_arr_to_number (map long-bool-cast oxygen_bin))
        co2 (parse_arr_to_number (map long-bool-cast co2_bin))]
      (* oxygen co2)))

(defn -main
  [& args]
  (def input (line-seq (java.io.BufferedReader. *in*)))
  (println (part1 input))
  (println (part2 input)))

