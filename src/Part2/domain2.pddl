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
        astronaut
        area
    )

    ; -------------------------------
    ; Predicates
    ; -------------------------------

    (:predicates
        ; positions
        (lander-at ?l - lander ?loc - location)
        (at ?r - rover ?loc - location)
        
        ; --- Map connectivity
        (path ?from - location ?to - location)

        ; rover ownership
        (assigned ?r - rover ?l - lander)
        
        ; Landing location
        (unplaced ?l - lander)

        ; deployment status
        (deployed ?r - rover)
        
        ; If lander had sample 
        (lander-free ?l - lander)
        
        ; data tasks
        (image-target ?img - image ?loc - location)
        (scan-target ?sc - scan ?loc - location)
        (taken ?d - data)
        (empty-memory ?r - rover)
        (holding-data ?r - rover ?d - data)
        (transmitted ?d - data ?l - lander)
        
        ; samples
        (sample-at ?s - sample ?loc - location)
        (holding-sample ?r - rover ?s - sample)
        (sample-collected ?s - sample)
        (sample-stored ?s - sample) 
        (stored ?s - sample ?l - lander)
        
        ; The astronaut is located in which area of the lander
        (crew-in ?a - astronaut ?l - lander ?ar - area)
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

    ; -------- 新动作：宇航员在 lander 内部移动 --------
    (:action move-crew
        :parameters (?a - astronaut ?l - lander ?from - area ?to - area)
        :precondition (crew-in ?a ?l ?from)
        :effect (and
            (crew-in ?a ?l ?to)
            (not (crew-in ?a ?l ?from))
        )
    )
    
    ; Deploy rover
    (:action deploy
        :parameters (?r - rover ?l - lander ?loc - location ?a - astronaut)
        :precondition (and
            (assigned ?r ?l)
            (lander-at ?l ?loc)
            (not (deployed ?r))
            (crew-in ?a ?l docking-bay)
        )
        :effect (and
            (deployed ?r)
            (at ?r ?loc)
        )
    )
    
    ;Retrieve rover
    (:action retrieve
        :parameters (?r - rover ?l - lander ?loc - location ?a - astronaut)
        :precondition (and
            (assigned ?r ?l)
            (deployed ?r)
            (at ?r ?loc)
            (lander-at ?l ?loc)
            (crew-in ?a ?l docking-bay)
        )
        :effect (and
            (not (deployed ?r))
            (not (at ?r ?loc))
        )
    )
    
    ; Move
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
        :parameters (?r - rover ?d - data ?l - lander ?a - astronaut)
        :precondition (and
            (assigned ?r ?l)
            (deployed ?r)
            (holding-data ?r ?d)
            (crew-in ?a ?l control-room)
        )
        :effect (and
            (transmitted ?d ?l)
            (empty-memory ?r)
            (not (holding-data ?r ?d))
        )
    )
    
    ; Pick up Sample
    (:action collect-sample
        :parameters (?r - rover ?s - sample ?loc - location)
        :precondition (and
            (deployed ?r)
            (at ?r ?loc)
            (sample-at ?s ?loc)
            (not (sample-collected ?s))
        )
        :effect (and
            (holding-sample ?r ?s)
            (sample-collected ?s)
            (not (sample-at ?s ?loc))
        )
    )
    
    ; Store Sample in Lander
    (:action store-sample
        :parameters (?r - rover ?s - sample ?l - lander ?a - astronaut)
        :precondition (and
            (not (deployed ?r)) 
            (holding-sample ?r ?s)
            (assigned ?r ?l)
            (lander-free ?l)
            (crew-in ?a ?l docking-bay)
        )
        :effect (and
            (stored ?s ?l)
            (sample-stored ?s)
            (not (holding-sample ?r ?s))
            (not (lander-free ?l))
        )
    )
) 