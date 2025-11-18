(define (problem lunar-mission-2)
    (:domain lunar)

    (:objects
        lander1 lander2 - lander
        rover1 rover2 - rover

        wp1 wp2 wp3 wp4 wp5 wp6 - location

        image2 image3 - image
        scan4 scan6 - scan

        sample1 sample5 - sample
    )

    (:init
        ; Rover assignments
        (assigned rover1 lander1)
        (assigned rover2 lander2)

        ; Rover initial deployment states
        ; Rover1 starts deployed at wp2 (with lander2)
        (not (unplaced lander1))
        
        (lander-at lander1 wp2)
        (at rover1 wp2)
        
        (deployed rover1)
        
        (lander-free lander1)
        (empty-memory rover1)
        
        ; Rover2 starts undeployed; lander2 unplaced (choose later)
        (unplaced lander2)
        
        (not (deployed rover2))
        
        (lander-free lander2)
        (empty-memory rover2)

        ; Map (Figure 3)
        (path wp1 wp2)
        (path wp2 wp1)
        (path wp2 wp3)
        (path wp3 wp5)
        (path wp5 wp3)
        (path wp5 wp6)
        (path wp6 wp4)
        (path wp2 wp4)
        (path wp4 wp2)

        ; task objective
        (image-target image2 wp2)
        (image-target image3 wp3)
        
        (scan-target scan4 wp4)
        (scan-target scan6 wp6)

        (sample-at sample1 wp1)
        (sample-at sample5 wp5)
    )

    (:goal
        (and
            ; Indicates that image5 has been captured
            (taken image2)
            (taken image3)
            
            ; Indicates that scan3 has been captured
            (taken scan4)
            (taken scan6)

            ; Indicates that sample1 has been collected and brought back
            (sample-stored sample1)
            (sample-stored sample5)
        )
    )
)
