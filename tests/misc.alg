(var (_acc binaryfunction initial count list) (rt RT_ACC_IDX binaryfunction initial count list))
(var (_mul a b) (rt RT_MUL_IDX a b))
(var (_sub c d) (rt RT_SUB_IDX c d))
(var (_add c d) (rt RT_ADD_IDX c d))
(var (_div c d) (rt RT_DIV_IDX c d))

(var (== a b) (rt RT_EQ_IDX a b))
// The RT function wants function first, but we put it last to make it easier to pass lambdas
(var (each collection fn) (rt RT_COLL_ITERATE_IDX fn collection))
(var (list vals...) vals...)
(var (reverse collection) (rt RT_COLL_REVERSE_IDX collection))
(var (ev x) x (eval))
(var (qprogn expr...) (each expr... ev))
// Quoted parameter means, compiler will quote the actual argument (in this case all, due to vararg)
(var (progn 'expr...) (each expr... ev))
(var (* a...) (_acc _mul 1 1 a...))
(var (+ a...) (_acc _add 0 1 a...))
// Note that we use the first argument as the start value, important for subtraction
(var (- a...) (_acc _sub (car a...) 1 (cdr a...)))
(var (/ a...) (_acc _div (car a...) 1 (cdr a...)))
(var (floor num) (rt RT_MATH_FLOOR_IDX num))
(var (car lst) (rt RT_COLL_GET_IDX lst 0))
(var (cdr lst) (rt RT_COLL_PROJECTION_IDX lst 1 0))
(var (contains? lst val) (rt RT_COLL_CONTAINS_IDX lst val))
(var (list-set lst index val) (rt RT_COLL_PUT_IDX lst val index))
(var (view lst start end) (rt RT_COLL_PROJECTION_IDX lst start end))
(var (len lst) (rt RT_COLL_SIZE_IDX lst))
// Copies the argument. For a list projection, this will create a proper list
(var (copy val) (rt RT_COPY_IDX val))
(var (quoted? val) (rt RT_IS_EXPRLIST_OBJECT_IDX val))

// Collections:
//  include -> includes matching items, same as filter
//  exclude -> excludes matching items, same as remove but makes it obvious that nothing is removed

// Test quoted progn, "qprogn". It only works for quoted input, otherwise input get
// evaluated. For unquoted progn, we need to implement macros (to avoid evaluation)
(qprogn '(print "progn1") '(print "progn2") '(print "progn3"))
(progn (print "prognA") (print "prognB") (print "prognC"))

// The operator is an accumulator, expected to a sequence, so turn arguments into a list
(var (infix 'a op 'b) (op (list (ev a) (ev b))))
(print "5*9 = ")
(print (infix 5 * 9))

// Returns true/false
(print "Is quoted?" (quoted? '(+ 1 3)) (quoted? (+ 7 8)))

(print "* 1..5 + 5 + 1 + 3:" (+ 5 1 3 (* 1 2 3 4 5)))
(print "Identity of mul is" (*))

// -5
(print "- 10 5 2 8:" (- 10 5 2 8))
(print "Right-identity of - is " (- 0))

// List of things
(var nums (list 1 2 3 4 5 6 7))
(print "nums: " nums)
(print "item#2: " (2 nums)) // todo: implement indexing
(print "cube 9 via lambda: " ((x => (* x x x)) 9))
// Update second value
(list-set nums 1 200)

// Print each value
(each nums (val => (print "val is " val)))

(print "Second item" (car (cdr nums)))
// Since we can't cdr a projection yet, we materialize it first
(print "Third item" (car (cdr (copy (cdr nums)))))

// Print projection (skip 3 from beginning, 2 from end)
(each (view nums 3 2) (val => (print "projected val is " val)))
(print "Contains 3?" (contains? nums 3))
(print "Lenght of nums is " (len nums))

(var (sumlist lst)
    (?  (== 1 (len lst))
            (car lst)
        (+ (car lst) (sumlist (copy (cdr lst))))))

(print "sumlist is: " (sumlist nums) "which should be same as " (+ nums))

(print "5/2 floored is "  (floor (/ 5 2)))

(var (vararg-counter arg...)
    (print "8 number of arguments passed? " (== 8 (len arg...))))
(vararg-counter 1 2 3 "." 4 5 '(1 2 3) 6)
