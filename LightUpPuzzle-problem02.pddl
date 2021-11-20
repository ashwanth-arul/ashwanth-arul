(define (problem problem01)
(:domain  LightUP_Puzzle)
(:objects
    x0 x1 x2 x3 x4 - xpos
    y0 y1 y2 y3 y4 - ypos
    n0 n1 n2 n3 n4 - num
	)

(:init 
    (black x1 y4)(black x2 y4)(black x3 y0)(black x3 y1)( black x3 y3)
    (right x0 x1)(right x0 x2)(right x0 x3)(right x0 x4)(right x1 x2)(right x1 x3)(right x1 x4)(right x2 x3)(right x2 x4)(right x3 x4)
    (left x4 x0)(left x4 x1)(left x4 x2)(left x4 x3)(left x3 x0)(left x3 x1)(left x3 x2)(left x2 x0)(left x2 x1)(left x1 x0)
    (below y0 y1)(below y0 y2)(below y0 y3)(below y0 y4)(below y1 y2)(below y1 y3)(below y1 y4)(below y2 y3)(below y2 y4)(below y3 y4)
    (above y4 y3)(above y4 y2)(above y4 y1)(above y4 y0)(above y3 y2) (above y3 y1)(above y3 y0)(above y2 y1)(above y2 y0)(above y1 y0)
    
    (increment n0 n1)(increment n1 n2)(increment n2 n3)(increment n3 n4)
    (surrounded x1 y4 n0)(surrounded x2 y4 n0)(surrounded x3 y1 n0)(surrounded x3 y3 n0)

    (adjacent x0 y0 x0 y1) (adjacent x0 y0 x1 y0)(adjacent x0 y1 x0 y0)(adjacent x0 y1 x1 y1)
    (adjacent x0 y1 x0 y2)(adjacent x0 y2 x0 y1)(adjacent x0 y2 x1 y2)(adjacent x0 y2 x0 y3)
    (adjacent x0 y3 x0 y2)(adjacent x0 y3 x1 y3)(adjacent x0 y3 x0 y4) (adjacent x0 y4 x0 y3)
    (adjacent x0 y4 x1 y4)
          
    (adjacent x1 y0 x0 y0)(adjacent x1 y0 x1 y1)(adjacent x1 y0 x2 y0) (adjacent x1 y1 x0 y1)
    (adjacent x1 y1 x1 y0)(adjacent x1 y1 x2 y1) (adjacent x1 y1 x1 y2)(adjacent x1 y2 x0 y2)
    (adjacent x1 y2 x1 y1)(adjacent x1 y2 x2 y2)(adjacent x1 y2 x1 y3)(adjacent x1 y3 x0 y3)
    (adjacent x1 y3 x1 y2) (adjacent x1 y3 x2 y3)(adjacent x1 y3 x1 y4)(adjacent x1 y4 x0 y4)
    (adjacent x1 y4 x1 y3)(adjacent x1 y4 x2 y4)
    
    (adjacent x2 y0 x1 y0)(adjacent x2 y0 x2 y1) (adjacent x2 y0 x3 y0)(adjacent x2 y1 x1 y1)
    (adjacent x2 y1 x2 y0)(adjacent x2 y1 x3 y1)(adjacent x2 y1 x2 y2)(adjacent x2 y2 x1 y2)
    (adjacent x2 y2 x2 y1) (adjacent x2 y2 x3 y2)(adjacent x2 y2 x2 y3)(adjacent x2 y3 x1 y3)
    (adjacent x2 y3 x2 y2)(adjacent x2 y3 x3 y3)(adjacent x2 y3 x2 y4) (adjacent x2 y4 x1 y4)
    (adjacent x2 y4 x2 y3)(adjacent x2 y4 x3 y4)
    
    (adjacent x3 y0 x2 y0)(adjacent x3 y0 x3 y1)(adjacent x3 y0 x4 y0)(adjacent x3 y1 x2 y1)
    (adjacent x3 y1 x3 y0)(adjacent x3 y1 x4 y1)(adjacent x3 y1 x3 y2)(adjacent x3 y2 x2 y2)
    (adjacent x3 y2 x3 y1)(adjacent x3 y2 x4 y2)(adjacent x3 y2 x3 y3)(adjacent x3 y3 x2 y3)
    (adjacent x3 y3 x3 y2)(adjacent x3 y3 x4 y3) (adjacent x3 y3 x3 y4)(adjacent x3 y4 x2 y4)
    (adjacent x3 y4 x3 y3)(adjacent x3 y4 x4 y4)
    
    (adjacent x4 y0 x3 y0)(adjacent x4 y0 x4 y1)(adjacent x4 y1 x4 y0) (adjacent x4 y1 x3 y1)
    (adjacent x4 y1 x4 y2)(adjacent x4 y2 x4 y1)(adjacent x4 y2 x3 y2)(adjacent x4 y2 x4 y3)
    (adjacent x4 y3 x4 y2) (adjacent x4 y3 x3 y3)(adjacent x4 y3 x4 y4)(adjacent x4 y4 x4 y3)
    (adjacent x4 y4 x3 y4)
      
    )
   (:goal (and 
        (lit x0 y0) (lit x0 y1) (lit x0 y2) (lit x0 y3) (lit x0 y4) 
        (lit x1 y0) (lit x1 y1) (lit x1 y2) (lit x1 y3)  
        (lit x2 y0) (lit x2 y1) (lit x2 y2) (lit x2 y3)  
        (lit x3 y2) (lit x3 y4) 
        (lit x4 y0) (lit x4 y1) (lit x4 y2) (lit x4 y3) (lit x4 y4)
        (surrounded x1 y4 n0)(surrounded x2 y4 n1)(surrounded x3 y1 n1)(surrounded x3 y3 n3)
        ))
    )