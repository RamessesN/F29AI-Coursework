(define (problem lunar-mission-1)
    (:domain lunar)

    (:objects
        lander1 - lander
        rover1 - rover
        
        wp1 wp2 wp3 wp4 wp5 wp6 - location
        
        image5 - image
        scan3 - scan
        
        sample1 - sample
    )

    (:init
        ; Rover ownership
        (assigned rover1 lander1)
        
        ; Land at any location
        (unplaced lander1)
        
        ; Deployment
        (not (deployed rover1))
        
        ; Lander can store sample 
        (lander-free lander1)
        
        ; The initial memory are empty.
        (empty-memory rover1)
        
        ; Map
        (path wp1 wp4)
        (path wp4 wp3)
        (path wp3 wp5)
        (path wp5 wp1)
        (path wp1 wp2)
        (path wp2 wp3)
        
        ; task objective
        (image-target image5 wp5)
        (scan-target scan3 wp3)
        (sample-at sample1 wp1)
    )

    (:goal
        (and
            ; Indicates that image5 has been captured
            (taken image5)
            ; Indicates that scan3 has been captured
            (taken scan3)
            ; Indicates that sample1 has been collected and brought back
            (sample-stored sample1) 
        )
    )
)