(define (domain lunar)
    (:requirements :strips :typing)

    ; -------------------------------
    ; Types
    ; -------------------------------
    
    (:types
        lander
        rover
        location
        sample
        data
        image scan - data
    )

    ; -------------------------------
    ; Predicates
    ; -------------------------------

    (:predicates
        ; Positions
        (lander-at ?l - lander ?loc - location)
        (at ?r - rover ?loc - location)
        
        ; Connectivity between surface locations
        (path ?from - location ?to - location)

        ; The association between rovers and their respective landers
        (assigned ?r - rover ?l - lander)
        
        ; Landing location
        (unplaced ?l - lander)

        ; Deployment status
        (deployed ?r - rover)
        
        ; If lander had not carried sample 
        (lander-free ?l - lander)
        
        ; Data tasks
        ; Data objectives
        (image-target ?img - image ?loc - location)
        (scan-target ?sc - scan ?loc - location)
        ; If data has been captured
        (taken ?d - data)
        ; If rover hold data
        (empty-memory ?r - rover)
        (holding-data ?r - rover ?d - data)
        ; If data has been transmitted to lander
        (transmitted ?d - data ?l - lander)
        
        ; Sample tasks
        ; Sample objectives
        (sample-at ?s - sample ?loc - location)
        ; If rover hold sample
        (holding-sample ?r - rover ?s - sample)
        ; Collection of sample
        (sample-picked-up ?s - sample)
        (sample-stored ?s - sample) 
        (stored ?s - sample ?l - lander)
    )

    ; -------------------------------
    ; Actions
    ; -------------------------------
    
    ; Landing location
    (:action choose-landing
        :parameters (?l - lander ?wp - location)
        :precondition
            (and (unplaced ?l))
        :effect
            (and
                (not (unplaced ?l))
                (lander-at ?l ?wp)
            )
    )

    ; Deploy rover
    (:action deploy
        :parameters (?r - rover ?l - lander ?loc - location)
        :precondition (and
            (assigned ?r ?l)
            (lander-at ?l ?loc)
            (not (deployed ?r))
        )
        :effect (and
            (deployed ?r)
            (at ?r ?loc)
        )
    )
    
    ;Retrieve rover
    (:action retrieve
        :parameters (?r - rover ?l - lander ?loc - location)
        :precondition (and
            (assigned ?r ?l)
            (deployed ?r)
            (at ?r ?loc)
            (lander-at ?l ?loc)
        )
        :effect (and
            (not (deployed ?r))
            (not (at ?r ?loc))
        )
    )
    
    ; Movement of rover
    (:action move
        :parameters (?r - rover ?from - location ?to - location)
        :precondition (and
            (deployed ?r)
            (at ?r ?from)
            (path ?from ?to)
        )
        :effect (and
            (at ?r ?to)
            (not (at ?r ?from))
        )
    )

    ; Take Image
    (:action take-image
        :parameters (?r - rover ?img - image ?loc - location)
        :precondition (and
            (deployed ?r)
            (at ?r ?loc)
            (image-target ?img ?loc)
            (empty-memory ?r)
            (not (taken ?img))
        )
        :effect (and
            (holding-data ?r ?img)
            (taken ?img)
            (not (empty-memory ?r))
        )
    )

    ; Perform Scan
    (:action scan
        :parameters (?r - rover ?sc - scan ?loc - location)
        :precondition (and
            (deployed ?r)
            (at ?r ?loc)
            (scan-target ?sc ?loc)
            (empty-memory ?r)
            (not (taken ?sc))
        )
        :effect (and
            (holding-data ?r ?sc)
            (taken ?sc)
            (not (empty-memory ?r))
        )
    )
    
    ; Transmit Data to Lander
    (:action transmit
        :parameters (?r - rover ?d - data ?l - lander)
        :precondition (and
            (assigned ?r ?l)
            (deployed ?r)
            (holding-data ?r ?d)
        )
        :effect (and
            (transmitted ?d ?l)
            (empty-memory ?r)
            (not (holding-data ?r ?d))
        )
    )
    
    ; Pick up Sample
    (:action pick-up-sample
        :parameters (?r - rover ?s - sample ?loc - location)
        :precondition (and
            (deployed ?r)
            (at ?r ?loc)
            (sample-at ?s ?loc)
            (not (sample-picked-up ?s))
        )
        :effect (and
            (holding-sample ?r ?s)
            (sample-picked-up ?s)
            (not (sample-at ?s ?loc))
        )
    )
    
    ; Store Sample in Lander
    (:action store-sample
        :parameters (?r - rover ?s - sample ?l - lander)
        :precondition (and
            (not (deployed ?r)) 
            (holding-sample ?r ?s)
            (assigned ?r ?l)
            (lander-free ?l)
        )
        :effect (and
            (stored ?s ?l)
            (sample-stored ?s)
            (not (holding-sample ?r ?s))
            (not (lander-free ?l))
        )
    )
)    
    
