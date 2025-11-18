(define (problem lunar-mission-1)
    (:domain lunar)

    (:objects
        lander1 - lander
        rover1 - rover
        ; Map
        wp1 wp2 wp3 wp4 wp5 wp6 - location
        ; Data
        image5 - image
        scan3 - scan
        ; Sample
        sample1 - sample
    )

    (:init
        ; The association between rover1 and lander1
        (assigned rover1 lander1)
        
        ; Lander1 can land at any location
        (unplaced lander1)
        
        ; Rover1 has not been deployed
        (not (deployed rover1))
        
        ; Lander1 has not stored sample
        (lander-free lander1)
        
        ; Rover1 memory is empty
        (empty-memory rover1)
        
        ; Connectivity between surface locations(Figure 2)
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