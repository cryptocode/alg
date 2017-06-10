(var (+ c d) (rt RT_ADD_IDX c d))
(var (- c d) (rt RT_SUB_IDX c d))
(var (<= a b) (rt RT_LT_EQ_IDX a b))

(var (fib n)
    (? (<= n 2) 1
       (+ (fib (- n 2)) (fib (- n 1)))))


(print "Fibonacci:" (fib 25))
