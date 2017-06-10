(var (* a b) (rt RT_MUL_IDX a b))
(var (+ c d) (rt RT_ADD_IDX c d))
(var (- c d) (rt RT_SUB_IDX c d))
(var (== a b) (rt RT_EQ_IDX a b))
(var (< a b) (rt RT_LT_IDX a b))

// Pure lambda expression computing factorial

(print "Factorial 5 is:"
(((lambda (X)
      ((lambda (procedure)
         (X (lambda (arg) ((procedure procedure) arg))))
       (lambda (procedure)
         (X (lambda (arg) ((procedure procedure) arg))))))
    (lambda (func-arg)
      (lambda (n)
        (? (== 0 n)
            1
            (* n (func-arg (- n 1)))))))
   5)
)

// Here we make the the Y combinator explicit:

(var Y
  (lambda (X)
    ((lambda (procedure)
       (X (lambda (arg) ((procedure procedure) arg))))
     (lambda (procedure)
       (X (lambda (arg) ((procedure procedure) arg)))))))

(var AlmostFib (lambda (funarg)
    (lambda (n) (? (< n 2) n (+ (funarg (- n 1)) (funarg (- n 2)))))))
(var fib (Y AlmostFib))

(print "Fib 15 is:" (fib 15))
