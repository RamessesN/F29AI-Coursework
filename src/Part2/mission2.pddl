(define (problem lunar-mission-2)
    (:domain lunar)

    (:objects
        lander1 lander2 - lander
        rover1 rover2 - rover
        ; Map
        wp1 wp2 wp3 wp4 wp5 wp6 - location
        ; Data
        image2 image3 - image
        scan4 scan6 - scan
        ; Sample
        sample1 sample5 - sample
    )

    (:init
        ; The association between rovers and their respective landers
        (assigned rover1 lander1)
        (assigned rover2 lander2)

        ; Rover initial deployment states
        ; Rover1 starts deployed at wp2 (with lander2 at wp2)
        (not (unplaced lander1))
        (lander-at lander1 wp2)
        (at rover1 wp2)
        (deployed rover1)
        
        ; Initial status
        (lander-free lander1)
        (empty-memory rover1)
        
        ; Rover2 starts undeployed (lander2 unplaced ( to be chosen))
        (unplaced lander2)
        (not (deployed rover2))
        
        ; Initial status of 1
        (lander-free lander2)
        (empty-memory rover2)

        ; Connectivity between surface locations(Figure 2)
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
        ; Image
        (image-target image2 wp2)
        (image-target image3 wp3)
        ; Scan
        (scan-target scan4 wp4)
        (scan-target scan6 wp6)
        ; Sample
        (sample-at sample1 wp1)
        (sample-at sample5 wp5)
    )

    (:goal
        (and
            ; Indicates that image2 and image3 have been captured
            (taken image2)
            (taken image3)
            
            ; Indicates that scan4 and scan6 have been captured
            (taken scan4)
            (taken scan6)

            ; Indicates that sample1 and sample5 have been collected(picked up and stored)
            (sample-stored sample1)
            (sample-stored sample5)
        )
    )
)
